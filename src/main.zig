const std = @import("std");
const crypto = @import("crypto");
const testing = @import("testing");

const VectorCommitment = struct {
    algorithm: crypto.HashAlgorithm,
    root: ?[]u8,
};

pub fn new(algorithm: crypto.HashAlgorithm) VectorCommitment {
    return VectorCommitment{
        .algorithm = algorithm,
        .root = null,
    };
}

pub fn commit(vc: *VectorCommitment, vectors: [][]u8) !?[]u8 {
    var leaves: [0]crypto.Hash = undefined;

    // Initialize the leaf nodes
    for (vectors) |vector| {
        var leaf: crypto.Hash = undefined;
        try leaf.init(vc.algorithm);
        try leaf.update(vector);
        leaves += leaf;
    }

    return calculateMerkleRootInternal(leaves, vc.algorithm);
}

pub fn verify(vc: VectorCommitment, vectors: [][]u8, commitment: []u8) !bool {
    const computedRoot = try commit(&vc, vectors);
    return std.mem.eql(u8, computedRoot, commitment);
}

fn calculateMerkleRootInternal(nodes: [0]crypto.Hash, algorithm: crypto.HashAlgorithm) !?[]u8 {
    if (nodes.len == 1) {
        // Reached the root
        return nodes[0].digest();
    }

    var nextLevel: [0]crypto.Hash = undefined;

    const levelSize = (nodes.len + 1) / 2; // Round up to the next integer

    // Compute the next level of nodes
    for (levelSize) |i| {
        var parentNode: crypto.Hash = undefined;
        try parentNode.init(algorithm);

        const leftChildIndex = i * 2;
        const rightChildIndex = i * 2 + 1;

        if (leftChildIndex < nodes.len) {
            try parentNode.update(nodes[leftChildIndex].digest());

            if (rightChildIndex < nodes.len) {
                try parentNode.update(nodes[rightChildIndex].digest());
            } else {
                // Duplicate the left child for odd-numbered levels
                try parentNode.update(nodes[leftChildIndex].digest());
            }
        }

        nextLevel += parentNode;
    }

    return calculateMerkleRootInternal(nextLevel, algorithm);
}

test "Vector Commitment Scheme" {
    var leafData: []const u8 = undefined;
    leafData = leafData ++ &[_]u8{ 'H', 'e', 'l', 'l', 'o' };
    leafData = leafData ++ &[_]u8{ 'W', 'o', 'r', 'l', 'd' };
    leafData = leafData ++ &[_]u8{ 'M', 'e', 'r', 'k', 'l', 'e' };
    leafData = leafData ++ &[_]u8{ 'R', 'o', 'o', 't' };

    const algorithm = crypto.HashAlgorithm.sha256;

    const vc = new(algorithm);

    const computedRoot = try vc.commit(leafData);
    testing.expect(vc.verify(leafData, computedRoot));
    testing.expect(!vc.verify(leafData[0..3], computedRoot));
    testing.expect(!vc.verify(leafData, computedRoot[0..30]));
}
