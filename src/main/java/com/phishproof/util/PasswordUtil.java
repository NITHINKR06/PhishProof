package com.phishproof.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * PasswordUtil — Wraps BCrypt password hashing and verification.
 */
public class PasswordUtil {

    private static final int BCRYPT_ROUNDS = 12;

    /** Hashes a plaintext password with BCrypt. */
    public static String hash(String plainText) {
        return BCrypt.hashpw(plainText, BCrypt.gensalt(BCRYPT_ROUNDS));
    }

    /** Returns true if plainText matches the stored BCrypt hash. */
    public static boolean verify(String plainText, String hash) {
        return BCrypt.checkpw(plainText, hash);
    }
}
