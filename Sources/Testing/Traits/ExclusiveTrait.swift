//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2025 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for Swift project authors
//

public struct ExclusiveTrait: TestTrait, SuiteTrait {}

// MARK: - TestScoping

extension ExclusiveTrait: TestScoping {
  public func provideScope(for test: Test, testCase: Test.Case?, performing function: @Sendable () async throws -> Void) async throws {
    guard var configuration = Configuration.current else {
      throw SystemError(description: "There is no current Configuration when attempting to provide scope for test '\(test.name)'. Please file a bug report at https://github.com/swiftlang/swift-testing/issues/new")
    }

    configuration.isParallelizationEnabled = false
    try await Configuration.withCurrent(configuration, perform: function)
  }
}

// MARK: -

extension Trait where Self == ExclusiveTrait {
  public static var exclusive: Self {
    Self()
  }
}
