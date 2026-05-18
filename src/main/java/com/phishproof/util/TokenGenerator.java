package com.phishproof.util;

import java.security.SecureRandom;
import java.util.Base64;

/**
 * TokenGenerator — Creates cryptographically secure URL-safe tokens
 * used to uniquely identify each phish link per user per campaign.
 */
public class TokenGenerator {

    private static final SecureRandom SECURE_RANDOM = new SecureRandom();
    private static final int TOKEN_BYTES = 32; // 256-bit token → 43 char Base64

    /**
     * Generates a unique URL-safe Base64 token.
     * Example: "a7Kx2mNpQrTsUvWx3yZaBcDeFgHiJkLm4nOpQrStUvWx5yZ"
     */
    public static String generate() {
        byte[] bytes = new byte[TOKEN_BYTES];
        SECURE_RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
