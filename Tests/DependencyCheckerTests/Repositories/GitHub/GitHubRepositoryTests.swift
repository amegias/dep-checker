@testable import DependencyChecker
import Foundation
@testable import Models
import Testing

struct GitHubRepositoryTests {
    // MARK: - Current version

    // MARK: Commit

    @Test
    func existingCommit_getCurrentVersionDate_returnsCurrentVersionDate() async {
        var gitHubClientMock = GitHubClientMock()
        gitHubClientMock.getCommitByRefMock = { _, _, _ in .any() }

        let sut = GitHubRepository(
            gitHubClient: gitHubClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .commit(hash: "abc"))
        )

        let currentVersionDate = await sut.getCurrentVersionDate()

        guard case .success(let date) = currentVersionDate else {
            #expect(Bool(false))
            return
        }
        #expect(date == GitHubCommit.any().commit.author!.date)
    }

    @Test
    func nonExistingCommit_getCurrentVersionDate_returnsNotFound() async {
        var gitHubClientMock = GitHubClientMock()
        gitHubClientMock.getCommitByRefMock = { _, _, _ in throw GitHubClient.APIError.notFound }

        let sut = GitHubRepository(
            gitHubClient: gitHubClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .commit(hash: "abc"))
        )

        let currentVersionDate = await sut.getCurrentVersionDate()

        guard case .failure(let error) = currentVersionDate else {
            #expect(Bool(false))
            return
        }
        #expect((error as? GitHubClient.APIError) == .notFound)
    }

    @Test
    func existingCommitWithoutAuthor_getCurrentVersionDate_returnsWrongPayload() async {
        var gitHubClientMock = GitHubClientMock()
        gitHubClientMock.getCommitByRefMock = { _, _, _ in .any(nil) }

        let sut = GitHubRepository(
            gitHubClient: gitHubClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .commit(hash: "abc"))
        )

        let currentVersionDate = await sut.getCurrentVersionDate()

        guard case .failure(let error) = currentVersionDate else {
            #expect(Bool(false))
            return
        }
        #expect((error as? RepositoryError) == .wrongPayload)
    }

    // MARK: Version

    @Test
    func existingVersionAsRelease_getCurrentVersionDate_returnsCurrentVersionDate() async {
        var gitHubClientMock = GitHubClientMock()
        gitHubClientMock.getReleaseMock = { version, _, _ in
            if version == "1.2.3" {
                return .any()
            } else {
                throw GitHubClient.APIError.notFound
            }
        }

        let sut = GitHubRepository(
            gitHubClient: gitHubClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .version(version: "1.2.3"))
        )

        let currentVersionDate = await sut.getCurrentVersionDate()

        guard case .success(let date) = currentVersionDate else {
            #expect(Bool(false))
            return
        }
        #expect(date == GitHubRelease.any().date)
    }

    @Test
    func existingVersionAsVRelease_getCurrentVersionDate_returnsCurrentVersionDate() async {
        var gitHubClientMock = GitHubClientMock()
        gitHubClientMock.getReleaseMock = { version, _, _ in
            if version == "v1.2.3" {
                return .any()
            } else {
                throw GitHubClient.APIError.notFound
            }
        }

        let sut = GitHubRepository(
            gitHubClient: gitHubClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .version(version: "1.2.3"))
        )

        let currentVersionDate = await sut.getCurrentVersionDate()

        guard case .success(let date) = currentVersionDate else {
            #expect(Bool(false))
            return
        }
        #expect(date == GitHubRelease.any().date)
    }

    @Test
    func existingVersionAsTag_getCurrentVersionDate_returnsCurrentVersionDate() async {
        var gitHubClientMock = GitHubClientMock()
        gitHubClientMock.getReleaseMock = { _, _, _ in throw GitHubClient.APIError.notFound }
        gitHubClientMock.getCommitByTagMock = { version, _, _ in
            if version == "1.2.3" {
                .any()
            } else {
                throw GitHubClient.APIError.notFound
            }
        }

        let sut = GitHubRepository(
            gitHubClient: gitHubClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .version(version: "1.2.3"))
        )

        let currentVersionDate = await sut.getCurrentVersionDate()

        guard case .success(let date) = currentVersionDate else {
            #expect(Bool(false))
            return
        }
        #expect(date == GitHubCommit.any().commit.author!.date)
    }

    @Test
    func existingVersionAsTagWithoutActor_getCurrentVersionDate_returnsNotFound() async {
        var gitHubClientMock = GitHubClientMock()
        gitHubClientMock.getReleaseMock = { _, _, _ in throw GitHubClient.APIError.notFound }
        gitHubClientMock.getCommitByTagMock = { version, _, _ in
            if version == "1.2.3" {
                .any(nil)
            } else {
                throw GitHubClient.APIError.notFound
            }
        }

        let sut = GitHubRepository(
            gitHubClient: gitHubClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .version(version: "1.2.3"))
        )

        let currentVersionDate = await sut.getCurrentVersionDate()

        guard case .failure(let error) = currentVersionDate else {
            #expect(Bool(false))
            return
        }
        #expect((error as? RepositoryError) == .wrongPayload)
    }

    // MARK: - Latest version

    @Test
    func existingLatestVersionAsRelease_getLatestVersion_returnsLatestVersion() async {
        var gitHubClientMock = GitHubClientMock()
        gitHubClientMock.getLatestReleaseMock = { _, _ in .any() }
        gitHubClientMock.getLatestTagMock = { _, _ in throw GitHubClient.APIError.notFound }

        let sut = GitHubRepository(
            gitHubClient: gitHubClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .version(version: "1.2.3"))
        )

        let latestVersion = await sut.getLatestVersion()

        guard case .success(let version) = latestVersion else {
            #expect(Bool(false))
            return
        }
        #expect(version.tag == "tag")
        #expect(version.date == GitHubRelease.any().date)
    }

    @Test
    func existingLatestVersionAsTag_getLatestVersion_returnsLatestVersion() async {
        var gitHubClientMock = GitHubClientMock()
        gitHubClientMock.getLatestReleaseMock = { _, _ in throw GitHubClient.APIError.notFound }
        gitHubClientMock.getLatestTagMock = { _, _ in ("tag", .any()) }

        let sut = GitHubRepository(
            gitHubClient: gitHubClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .version(version: "1.2.3"))
        )

        let latestVersion = await sut.getLatestVersion()

        guard case .success(let version) = latestVersion else {
            #expect(Bool(false))
            return
        }
        #expect(version.tag == "tag")
        #expect(version.date == GitHubCommit.any().commit.author?.date)
    }

    @Test
    func existingLatestVersionAsTagWithoutAuthor_getLatestVersion_returnsError() async {
        var gitHubClientMock = GitHubClientMock()
        gitHubClientMock.getLatestReleaseMock = { _, _ in throw GitHubClient.APIError.notFound }
        gitHubClientMock.getLatestTagMock = { _, _ in ("tag", .any(nil)) }

        let sut = GitHubRepository(
            gitHubClient: gitHubClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .version(version: "1.2.3"))
        )
        let latestVersion = await sut.getLatestVersion()

        guard case .failure(let error) = latestVersion else {
            #expect(Bool(false))
            return
        }
        #expect(error as? RepositoryError == .wrongPayload)
    }

    @Test
    func notExistingLatestVersion_getLatestVersion_returnsNotFound() async {
        var gitHubClientMock = GitHubClientMock()
        gitHubClientMock.getLatestReleaseMock = { _, _ in throw GitHubClient.APIError.notFound }
        gitHubClientMock.getLatestTagMock = { _, _ in throw GitHubClient.APIError.notFound }

        let sut = GitHubRepository(
            gitHubClient: gitHubClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .version(version: "1.2.3"))
        )

        let latestVersion = await sut.getLatestVersion()

        guard case .failure(let error) = latestVersion else {
            #expect(Bool(false))
            return
        }
        #expect(error as? GitHubClient.APIError == .notFound)
    }
}

private struct GitHubClientMock: GitHubClientProtocol {
    var getLatestReleaseMock: @Sendable (_ owner: String, _ repo: String) async throws -> GitHubRelease = { _, _ in
        .any()
    }

    func getLatestRelease(_ owner: String, _ repo: String) async throws -> GitHubRelease {
        try await getLatestReleaseMock(owner, repo)
    }

    var getLatestTagMock: @Sendable (_ owner: String, _ repo: String) async throws -> (
        tag: String,
        commit: GitHubCommit
    ) = { _, _ in ("tag", .any()) }
    func getLatestTag(_ owner: String, _ repo: String) async throws -> (tag: String, commit: GitHubCommit) {
        try await getLatestTagMock(owner, repo)
    }

    var getReleaseMock: @Sendable (_ tag: String, _ owner: String, _ repo: String) async throws
        -> GitHubRelease = { _, _, _ in
            .any()
        }

    func getRelease(_ tag: String, _ owner: String, _ repo: String) async throws -> GitHubRelease {
        try await getReleaseMock(tag, owner, repo)
    }

    var getCommitByRefMock: @Sendable (_ ref: String, _ owner: String, _ repo: String) async throws
        -> GitHubCommit = { _, _, _ in
            .any()
        }

    func getCommitByRef(_ ref: String, _ owner: String, _ repo: String) async throws -> GitHubCommit {
        try await getCommitByRefMock(ref, owner, repo)
    }

    var getCommitByTagMock: @Sendable (_ tag: String, _ owner: String, _ repo: String) async throws
        -> GitHubCommit = { _, _, _ in
            .any()
        }

    func getCommitByTag(_ tag: String, _ owner: String, _ repo: String) async throws -> GitHubCommit {
        try await getCommitByTagMock(tag, owner, repo)
    }
}

private extension GitHubRelease {
    static func any() -> GitHubRelease {
        GitHubRelease(
            created_at: Date(timeIntervalSince1970: 30_000_000),
            published_at: nil,
            tag_name: "tag"
        )
    }
}

private extension GitHubCommit {
    static func any(
        _ author: InternalCommit.Author? = GitHubCommit.InternalCommit
            .Author(date: Date(timeIntervalSince1970: 20_000_000))
    ) -> GitHubCommit {
        GitHubCommit(commit: InternalCommit(author: author))
    }
}
