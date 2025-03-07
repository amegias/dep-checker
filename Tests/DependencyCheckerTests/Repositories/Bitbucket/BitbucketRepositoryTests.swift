@testable import DependencyChecker
import Foundation
@testable import Models
import Testing

struct BitbucketRepositoryTests {
    // MARK: - Current version

    // MARK: Commit

    @Test
    func existingCommit_getCurrentVersionDate_returnsCurrentVersionDate() async {
        let stubbedDate = Date(timeIntervalSince1970: 100_000_000)
        var bitbucketClientMock = BitbucketClientMock()
        bitbucketClientMock.getCommitMock = { _, _, _ in BitbucketCommit(date: stubbedDate) }

        let sut = BitbucketRepository(
            bitbucketClient: bitbucketClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .commit(hash: "abc"))
        )

        let currentVersionDate = await sut.getCurrentVersionDate()

        guard case .success(let date) = currentVersionDate else {
            #expect(Bool(false))
            return
        }
        #expect(date == stubbedDate)
    }

    @Test
    func nonExistingCommit_getCurrentVersionDate_returnsNotFound() async {
        var bitbucketClientMock = BitbucketClientMock()
        bitbucketClientMock.getCommitMock = { _, _, _ in throw BitbucketClient.APIError.notFound }

        let sut = BitbucketRepository(
            bitbucketClient: bitbucketClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .commit(hash: "abc"))
        )

        let currentVersionDate = await sut.getCurrentVersionDate()

        guard case .failure(let error) = currentVersionDate else {
            #expect(Bool(false))
            return
        }
        #expect((error as? BitbucketClient.APIError) == .notFound)
    }

    // MARK: Version

    @Test
    func existingVersionAsTag_getCurrentVersionDate_returnsCurrentVersionDate() async {
        var bitbucketClientMock = BitbucketClientMock()
        bitbucketClientMock.getTagMock = { _, _, _ in .any() }

        let sut = BitbucketRepository(
            bitbucketClient: bitbucketClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .version(version: "1.2.3"))
        )

        let currentVersionDate = await sut.getCurrentVersionDate()

        guard case .success(let date) = currentVersionDate else {
            #expect(Bool(false))
            return
        }
        #expect(date == BitbucketTag.any().target.date)
    }

    @Test
    func nonExistingVersionAsTag_getCurrentVersionDate_returnsNotFound() async {
        var bitbucketClientMock = BitbucketClientMock()
        bitbucketClientMock.getTagMock = { version, _, _ in
            if version == "1.2.3" {
                throw BitbucketClient.APIError.notFound
            } else {
                return .any()
            }
        }

        let sut = BitbucketRepository(
            bitbucketClient: bitbucketClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .version(version: "1.2.3"))
        )

        let currentVersionDate = await sut.getCurrentVersionDate()

        guard case .failure(let error) = currentVersionDate else {
            #expect(Bool(false))
            return
        }
        #expect((error as? BitbucketClient.APIError) == .notFound)
    }

    @Test
    func versionAsNonExact_getCurrentVersionDate_returnsNonExactVersionTypeError() async {
        var bitbucketClientMock = BitbucketClientMock()
        bitbucketClientMock.getTagMock = { _, _, _ in .any() }
        bitbucketClientMock.getCommitMock = { _, _, _ in BitbucketCommit(date: Date()) }

        let sut = BitbucketRepository(
            bitbucketClient: bitbucketClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .nonExact("master"))
        )

        let currentVersionDate = await sut.getCurrentVersionDate()

        guard case .failure(let error) = currentVersionDate else {
            #expect(Bool(false))
            return
        }
        #expect((error as? RepositoryError) == .nonExactVersionType("master"))
    }

    // MARK: - Latest version

    @Test
    func existingLatestVersionAsTag_getLatestVersion_returnsLatestVersion() async {
        var bitbucketClientMock = BitbucketClientMock()
        bitbucketClientMock.getLatestTagMock = { _, _ in .any() }

        let sut = BitbucketRepository(
            bitbucketClient: bitbucketClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .version(version: "1.2.3"))
        )

        let latestVersion = await sut.getLatestVersion()

        guard case .success(let version) = latestVersion else {
            #expect(Bool(false))
            return
        }
        #expect(version.tag == BitbucketTag.any().name)
        #expect(version.date == BitbucketTag.any().target.date)
    }

    @Test
    func nonExistingLatestVersionAsTag_getLatestVersion_returnsNotFound() async {
        var bitbucketClientMock = BitbucketClientMock()
        bitbucketClientMock.getLatestTagMock = { _, _ in throw BitbucketClient.APIError.notFound }

        let sut = BitbucketRepository(
            bitbucketClient: bitbucketClientMock,
            owner: "owner",
            repository: "repo",
            dependency: .any(name: "any", pointingTo: .version(version: "1.2.3"))
        )

        let latestVersion = await sut.getLatestVersion()

        guard case .failure(let error) = latestVersion else {
            #expect(Bool(false))
            return
        }
        #expect((error as? BitbucketClient.APIError) == .notFound)
    }
}

private struct BitbucketClientMock: BitbucketClientProtocol {
    var getLatestTagMock: @Sendable (_ owner: String, _ repo: String) async throws -> BitbucketTag = { _, _ in .any() }
    func getLatestTag(_ owner: String, _ repo: String) async throws -> BitbucketTag {
        try await getLatestTagMock(owner, repo)
    }

    var getTagMock: @Sendable (_ tag: String, _ owner: String, _ repo: String) async throws
        -> BitbucketTag = { _, _, _ in
            .any()
        }

    func getTag(_ tag: String, _ owner: String, _ repo: String) async throws -> BitbucketTag {
        try await getTagMock(tag, owner, repo)
    }

    var getCommitMock: @Sendable (_ ref: String, _ owner: String, _ repo: String) async throws
        -> BitbucketCommit = { _, _, _ in
            BitbucketCommit(date: Date(timeIntervalSince1970: 0))
        }

    func getCommit(_ ref: String, _ owner: String, _ repo: String) async throws -> BitbucketCommit {
        try await getCommitMock(ref, owner, repo)
    }
}

private extension BitbucketTag {
    static func any(_ date: Date = Date(timeIntervalSince1970: 20_000_000)) -> BitbucketTag {
        BitbucketTag(
            name: "tag",
            target: Target(date: date)
        )
    }
}
