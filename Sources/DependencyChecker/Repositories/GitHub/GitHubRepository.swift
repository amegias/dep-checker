import Foundation
import Models
import OSLog

struct GitHubRepository {
    private let gitHubClient: GitHubClientProtocol

    let owner: String
    let repository: String
    let dependency: AnalyzedDependency

    init(
        gitHubToken: String,
        owner: String,
        repository: String,
        dependency: AnalyzedDependency
    ) {
        gitHubClient = GitHubClient(gitHubToken: gitHubToken)
        self.owner = owner
        self.repository = repository
        self.dependency = dependency
    }

    init(
        gitHubClient: GitHubClientProtocol,
        owner: String,
        repository: String,
        dependency: AnalyzedDependency
    ) {
        self.gitHubClient = gitHubClient
        self.owner = owner
        self.repository = repository
        self.dependency = dependency
    }
}

extension GitHubRepository: Repository {
    func getCurrentVersionDate() async -> CustomResult<Date, Error> {
        switch dependency.pointingTo {
        case let .commit(hash: hash):
            do {
                let commit = try await gitHubClient.getCommitByRef(hash, owner, repository)
                guard let author = commit.commit.author else {
                    Logger.gitHubRepository
                        .error("[\(repository) / getCurrentVersionDate]: Error: author not found in the payload")
                    return .failure(RepositoryError.wrongPayload)
                }
                Logger.gitHubRepository.debug("[\(repository) / getCurrentVersionDate]: Found as commit")
                return .success(author.date)
            } catch {
                Logger.gitHubRepository.debug("[\(repository) / getCurrentVersionDate]: Error: \(error)")
                return .failure(error)
            }

        case let .version(version):
            do {
                let release = try await gitHubClient.getRelease(version, owner, repository)
                Logger.gitHubRepository.debug("[\(repository) / getCurrentVersionDate]: Found as release")
                return .success(release.date)
            } catch GitHubClient.APIError.notFound {
                do {
                    let tag = "v\(version)"
                    let release = try await gitHubClient.getRelease(tag, owner, repository)
                    Logger.gitHubRepository
                        .debug("[\(repository) / getCurrentVersionDate]: Found as release with v preffix")
                    return .success(release.date)
                } catch GitHubClient.APIError.notFound {
                    return await getCurrentVersionDateAsTag(tag: version)
                } catch {
                    Logger.gitHubRepository.debug("[\(repository) / getCurrentVersionDate]: Error: \(error)")
                    return .failure(error)
                }
            } catch {
                Logger.gitHubRepository.debug("[\(repository) / getCurrentVersionDate]: Error: \(error)")
                return .failure(error)
            }

        case .nonExact(let string):
            let error = RepositoryError.nonExactVersionType(string)
            Logger.gitHubRepository.debug("[\(repository) / getCurrentVersionDate]: error \(error)")
            return .failure(error)
        }
    }

    func getLatestVersion() async -> CustomResult<LatestVersion, any Error> {
        do {
            let release = try await gitHubClient.getLatestRelease(owner, repository)
            Logger.gitHubRepository.debug("[\(repository) / getLatestVersion]: Found latest release")
            return .success(LatestVersion(tag: release.tag_name, date: release.date))
        } catch GitHubClient.APIError.notFound {
            return await getLatestTag()
        } catch {
            Logger.gitHubRepository.debug("[\(repository) / getLatestVersion]: Error: \(error)")
            return .failure(error)
        }
    }
}

private extension GitHubRepository {
    func getCurrentVersionDateAsTag(tag: String) async -> CustomResult<Date, Error> {
        do {
            let commit = try await gitHubClient.getCommitByTag(tag, owner, repository)
            guard let author = commit.commit.author else {
                Logger.gitHubRepository
                    .error("[\(repository) / getCurrentVersionDate]: Error: author not found in the payload")
                return .failure(RepositoryError.wrongPayload)
            }
            Logger.gitHubRepository.debug("[\(repository) / getCurrentVersionDate]: found as tag")
            return .success(author.date)
        } catch {
            Logger.gitHubRepository.debug("[\(repository) / getCurrentVersion]: Error: \(error)")
            return .failure(error)
        }
    }

    func getLatestTag() async -> CustomResult<LatestVersion, Error> {
        do {
            let (tag, commit) = try await gitHubClient.getLatestTag(owner, repository)
            guard let author = commit.commit.author else {
                Logger.gitHubRepository
                    .error("[\(repository) / getLatestVersion]: Error: author not found in the payload")
                throw RepositoryError.wrongPayload
            }
            Logger.gitHubRepository.debug("[\(repository) / getLatestVersion]: Found latest tag")
            return .success(LatestVersion(tag: tag, date: author.date))
        } catch {
            Logger.gitHubRepository.debug("[\(repository) / getLatestVersion]: Error: \(error)")
            return .failure(error)
        }
    }
}
