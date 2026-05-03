#!/bin/bash

# Test script for extract-docker API
# This script demonstrates how to use the extract API

set -e

HOST="${1:-http://localhost:3000}"
echo "Testing extract API at $HOST"
echo "================================"

# Test 1: Health check
echo ""
echo "Test 1: Health Check"
echo "  GET $HOST/health"
curl -s -w "\n  Status: %{http_code}\n" "$HOST/health" | head -20
echo ""

# Test 2: Example extraction (requires auth)
# NOTE: Replace with actual username, signature, and URL
echo "Test 2: Article Extraction"
echo "  Example: GET $HOST/parser/<username>/<signature>?base64_url=<base64_url>"
echo ""
echo "  To test extraction:"
echo "  1. Replace <username> with your username"
echo "  2. Replace <signature> with a valid HMAC-SHA256 signature"
echo "  3. Replace <base64_url> with a base64-encoded webpage URL"
echo ""
echo "  Example URL (base64 encoded):"
echo "    https://example.com → aHR0cHM6Ly9leGFtcGxlLmNvbQ=="
echo ""
echo "  Usage:"
echo "    curl '$HOST/parser/user123/signature123?base64_url=aHR0cHM6Ly9leGFtcGxlLmNvbQ=='"
echo ""

# Test 3: Check if service is running
echo "Test 3: Service Status"
if curl -s "$HOST/health" > /dev/null 2>&1; then
    echo "  ✓ Service is running and responding"
else
    echo "  ✗ Service is not responding"
    exit 1
fi

echo ""
echo "✓ All basic tests passed"
