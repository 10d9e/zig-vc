# zig-vc

# Zig Vector Commitment Library

This repository contains an implementation of a Vector Commitment scheme in Zig. Vector Commitments are cryptographic primitives that allow for the commitment and verification of a set of elements, commonly referred to as a vector.

## What is a Vector Commitment?

A Vector Commitment is a cryptographic primitive that allows one to commit to a vector of elements and later prove that a specific element is a member of the committed vector, without revealing any other information about the vector. It provides a way to securely prove the membership or non-membership of elements in a set, even when the set is large or infinite.

## How to Use

### Requirements

- Zig 0.10.1 or later
- The `crypto` library (included in the code)

### Getting Started

1. Clone this repository:

   ```shell
    $ git clone https://github.com/your-username/vector-commitment.git
   ```

2. Change into the project directory:

   ```shell
    Copy code
    $ cd vector-commitment
   ```

3. Build and run the code:

    ```shell
    $ zig build run
    ```

## Example Usage
To use the Vector Commitment scheme in your own Zig projects, you can follow these steps:

1. Copy the vc.zig file into your project.


2. Import the necessary dependencies:

```zig
const crypto = @import("crypto");
const vc = @import("vc.zig");
```

3. Create a new Vector Commitment instance:

```zig
const algorithm = crypto.HashAlgorithm.sha256;
const commitment = vc.new(algorithm);
```

4. Prepare the vectors you want to commit to:

```zig
var vectors: [][]u8 = null;
vectors = vectors ++ &[_]u8{ 'H', 'e', 'l', 'l', 'o' };
vectors = vectors ++ &[_]u8{ 'W', 'o', 'r', 'l', 'd' };
vectors = vectors ++ &[_]u8{ 'M', 'e', 'r', 'k', 'l', 'e' };
vectors = vectors ++ &[_]u8{ 'R', 'o', 'o', 't' };
```

5. Commit the vectors:

```zig
const committedRoot = try commitment.commit(vectors);
```

6. Verify the commitment:

```zig
const verified = try commitment.verify(vectors, committedRoot);
if (verified) {
    // Vectors are verified
} else {
    // Vectors are not verified
}
```

The `verify` function returns `true` if the vectors are verified and false otherwise.

For more details on the functions and usage, refer to the code comments in vc.zig.

# Contributing
Contributions to this project are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request.

# License
This project is licensed under the MIT License.

