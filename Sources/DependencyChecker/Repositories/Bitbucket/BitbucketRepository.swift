import Foundation
import Models
import OSLog

struct BitbucketRepository {
    private let bitbucketClient: BitbucketClientProtocol

    let owner: String
    let repository: String
    let dependency: AnalyzedDependency

    init(
        bitbucketClient: BitbucketClientProtocol = BitbucketClient(),
        owner: String,
        repository: String,
        dependency: AnalyzedDependency
    ) {
        self.bitbucketClient = bitbucketClient
        self.owner = owner
        self.repository = repository
        self.dependency = dependency
    }
}

extension BitbucketRepository: Repository {
    func getCurrentVersionDate() async -> CustomResult<Date, Error> {
        switch dependency.pointingTo {
        case let .commit(hash: hash):
            do {
                let commit = try await bitbucketClient.getCommit(hash, owner, repository)
                Logger.bitbucketRepository.debug("[\(repository) / getCurrentVersionDate]: commit found")
                return .success(commit.date)
            } catch {
                Logger.bitbucketRepository.debug("[\(repository) / getCurrentVersionDate]: error \(error)")
                return .failure(error)
            }

        case let .version(version):
            do {
                let tag = try await bitbucketClient.getTag(version, owner, repository)
                Logger.bitbucketRepository.debug("[\(repository) / getCurrentVersionDate]: tag found")
                return .success(tag.target.date)
            } catch {
                Logger.bitbucketRepository.debug("[\(repository) / getCurrentVersionDate]: error \(error)")
                return .failure(error)
            }

        case .nonExact(let string):
            let error = RepositoryError.nonExactVersionType(string)
            Logger.bitbucketRepository.debug("[\(repository) / getCurrentVersionDate]: error \(error)")
            return .failure(error)
        }
    }

    func getLatestVersion() async -> CustomResult<LatestVersion, any Error> {
        do {
            let tag = try await bitbucketClient.getLatestTag(owner, repository)
            Logger.bitbucketRepository.debug("[\(repository) / getLatestVersion]: Latest tag found")
            return .success(LatestVersion(
                tag: tag.name,
                date: tag.target.date
            ))
        } catch {
            Logger.bitbucketRepository.debug("[\(repository) / getLatestVersion]: error \(error)")
            return .failure(error)
        }
    }
}
