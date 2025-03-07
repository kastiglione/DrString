enum WhateverParameterStyle {
    // CHECK-NOT: Parameters are organized
    /// Description
    ///
    /// - Parameter foo: foo description
    /// - Parameter bar: bar description
    func f(foo: Int, bar: Int) {}

    // CHECK: Parameters are organized
    /// Description
    /// - Parameters:
    ///   - foo: foo description
    ///   - bar: bar description
    func g(foo: Int, bar: Int) {}

    // CHECK-NOT: Parameters are organized
    /// Description
    ///
    /// - Parameter foo: foo description
    func h(foo: Int) {}

    // CHECK-NOT: Parameters are organized
    /// Description
    ///
    /// - Parameters:
    ///   - foo: foo description
    func i(foo: Int) {}
}
