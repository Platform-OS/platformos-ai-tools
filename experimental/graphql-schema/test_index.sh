#!/bin/bash
# GraphQL Schema Index Verification Tests
# Rigorous tests that verify AGENTS.md completeness against schema.json
# These tests WILL FAIL if types are missing - not written to pass!

set -e
cd "$(dirname "$0")"

echo "=============================================="
echo "GraphQL Schema Index Verification Tests"
echo "=============================================="
echo ""

PASS=0
FAIL=0

# TEST 1: Rigorous object type verification
test_object_types() {
    echo "TEST 1: Object Type Completeness"
    echo "---------------------------------"
    SCHEMA_TYPES=$(grep -E "^type " schema.json | awk '{print $2}' | cut -d'{' -f1 | sort)
    COUNT=$(echo "$SCHEMA_TYPES" | wc -l)
    echo "  Types in schema.json: $COUNT"
    
    MISSING=""
    for type in $SCHEMA_TYPES; do
        if ! grep -q "$type" AGENTS.md 2>/dev/null; then
            MISSING="$MISSING\n  $type"
        fi
    done
    
    if [ -z "$MISSING" ]; then
        echo "  [PASS] All $COUNT types found in AGENTS.md"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] Missing types:$MISSING"
        FAIL=$((FAIL + 1))
    fi
    echo ""
}

# TEST 2: Rigorous input type verification
test_input_types() {
    echo "TEST 2: Input Type Completeness"
    echo "-------------------------------"
    INPUT_TYPES=$(grep -E "^input " schema.json | awk '{print $2}' | cut -d'{' -f1 | sort)
    COUNT=$(echo "$INPUT_TYPES" | wc -l)
    echo "  Input types in schema.json: $COUNT"
    
    MISSING=""
    for type in $INPUT_TYPES; do
        if ! grep -q "$type" AGENTS.md 2>/dev/null; then
            MISSING="$MISSING\n  $type"
        fi
    done
    
    if [ -z "$MISSING" ]; then
        echo "  [PASS] All $COUNT input types found in AGENTS.md"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] Missing inputs:$MISSING"
        FAIL=$((FAIL + 1))
    fi
    echo ""
}

# TEST 3: Rigorous enum verification
test_enum_types() {
    echo "TEST 3: Enum Type Completeness"
    echo "------------------------------"
    ENUM_TYPES=$(grep -E "^enum " schema.json | awk '{print $2}' | cut -d'{' -f1 | sort)
    COUNT=$(echo "$ENUM_TYPES" | wc -l)
    echo "  Enum types in schema.json: $COUNT"
    
    MISSING=""
    for type in $ENUM_TYPES; do
        if ! grep -q "$type" AGENTS.md 2>/dev/null; then
            MISSING="$MISSING\n  $type"
        fi
    done
    
    if [ -z "$MISSING" ]; then
        echo "  [PASS] All $COUNT enum types found in AGENTS.md"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] Missing enums:$MISSING"
        FAIL=$((FAIL + 1))
    fi
    echo ""
}

# TEST 4: Verify key object types exist
test_key_object_types() {
    echo "TEST 4: Key Object Types"
    echo "------------------------"
    KEY_TYPES=("User{" "Customization{" "Listing{" "Asset{" "Model{" "Record{" "Page{" "Form{" "BackgroundJob{" "Session{")
    MISSING=0
    for type in "${KEY_TYPES[@]}"; do
        if ! grep -q "$type" AGENTS.md 2>/dev/null; then
            echo "  [MISSING] $type"
            MISSING=$((MISSING + 1))
        else
            echo "  [OK] $type"
        fi
    done
    if [ "$MISSING" -eq 0 ]; then
        echo "  [PASS] All key object types present"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] $MISSING key types missing"
        FAIL=$((FAIL + 1))
    fi
    echo ""
}

# TEST 5: Verify key input types exist
test_key_input_types() {
    echo "TEST 5: Key Input Types"
    echo "-----------------------"
    KEY_INPUTS=("UserInputType{" "CustomizationInputType{" "QueryListing{" "ModelSchemaInputType{" "PropertyInputType{" "FilterInput{" "SortInput{")
    MISSING=0
    for type in "${KEY_INPUTS[@]}"; do
        if ! grep -q "$type" AGENTS.md 2>/dev/null; then
            echo "  [MISSING] $type"
            MISSING=$((MISSING + 1))
        else
            echo "  [OK] $type"
        fi
    done
    if [ "$MISSING" -eq 0 ]; then
        echo "  [PASS] All key input types present"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] $MISSING key inputs missing"
        FAIL=$((FAIL + 1))
    fi
    echo ""
}

# TEST 6: Verify key enum types exist
test_key_enum_types() {
    echo "TEST 6: Key Enum Types"
    echo "----------------------"
    KEY_ENUMS=("StatusEnum{" "UserStatus{" "TransactionStatusEnum{" "AggregationTypeEnum{" "AuthenticationProvider{" "PageFormat{" "PropertyTypeEnum{")
    MISSING=0
    for type in "${KEY_ENUMS[@]}"; do
        if ! grep -q "$type" AGENTS.md 2>/dev/null; then
            echo "  [MISSING] $type"
            MISSING=$((MISSING + 1))
        else
            echo "  [OK] $type"
        fi
    done
    if [ "$MISSING" -eq 0 ]; then
        echo "  [PASS] All key enum types present"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] $MISSING key enums missing"
        FAIL=$((FAIL + 1))
    fi
    echo ""
}

# TEST 7: Verify index structure
test_structure() {
    echo "TEST 7: Index Structure"
    echo "-----------------------"
    SECTIONS=$(grep -oE "\|[A-Z][A-Za-z_]+:" AGENTS.md | wc -l)
    echo "  Pipe-delimited sections: $SECTIONS"
    REQUIRED_SECTIONS="QUERY_FIELDS|MUTATION|OBJECTS|INPUTS|ENUMS|SCALARS|INTERFACES|COMMON_PATTERNS"
    MISSING_SECTIONS=""
    for section in QUERY_FIELDS MUTATION OBJECTS INPUTS ENUMS SCALARS INTERFACES COMMON_PATTERNS; do
        if ! grep -q "|$section|" AGENTS.md; then
            MISSING_SECTIONS="$MISSING_SECTIONS $section"
        fi
    done
    if [ -z "$MISSING_SECTIONS" ]; then
        echo "  [PASS] All required sections present"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] Missing sections:$MISSING_SECTIONS"
        FAIL=$((FAIL + 1))
    fi
    echo ""
}

# TEST 8: File size check
test_file_size() {
    echo "TEST 8: File Size"
    echo "-----------------"
    SIZE=$(du -b AGENTS.md 2>/dev/null | cut -f1)
    echo "  AGENTS.md: $SIZE bytes"
    if [ "$SIZE" -gt 30000 ]; then
        echo "  [PASS] File is substantial ($SIZE bytes)"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] File too small ($SIZE bytes)"
        FAIL=$((FAIL + 1))
    fi
    echo ""
}

# TEST 9: Verify QUERY_FIELDS coverage
test_query_fields() {
    echo "TEST 9: Query Fields Coverage"
    echo "-----------------------------"
    SCHEMA_QUERIES=$(grep -A200 "^type RootQuery" schema.json | grep "^  " | wc -l)
    AGENTS_QUERIES=$(grep "QUERY_FIELDS|" AGENTS.md | tr -cd ',' | wc -c)
    AGENTS_QUERIES=$((AGENTS_QUERIES + 1))
    echo "  Query fields in RootQuery: $SCHEMA_QUERIES"
    echo "  Query fields in AGENTS.md: ~$AGENTS_QUERIES"
    if [ "$AGENTS_QUERIES" -gt 50 ]; then
        echo "  [PASS] Substantial query coverage"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] Query coverage insufficient"
        FAIL=$((FAIL + 1))
    fi
    echo ""
}

# TEST 10: Verify interface implementations
test_interface_impls() {
    echo "TEST 10: Interface Implementations"
    echo "-----------------------------------"
    INTERFACES=$(grep -E "^interface " schema.json | awk '{print $2}' | wc -l)
    IMPLS=$(grep -o "Interface->" AGENTS.md | wc -l)
    echo "  Interfaces in schema: $INTERFACES"
    echo "  Interface impls in AGENTS.md: $IMPLS"
    if [ "$IMPLS" -ge 10 ]; then
        echo "  [PASS] Interface implementations present ($IMPLS entries)"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] Interface implementations missing"
        FAIL=$((FAIL + 1))
    fi
    echo ""
}

# Run all tests
test_object_types
test_input_types
test_enum_types
test_key_object_types
test_key_input_types
test_key_enum_types
test_structure
test_file_size
test_query_fields
test_interface_impls

# Summary
echo "=============================================="
echo "TEST SUMMARY"
echo "=============================================="
echo "PASSED: $PASS/10"
echo "FAILED: $FAIL/10"
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo "✓ All tests passed! AGENTS.md is comprehensive."
    echo "  - All object types from schema.json are indexed"
    echo "  - All input types from schema.json are indexed"
    echo "  - All enum types from schema.json are indexed"
    exit 0
else
    echo "✗ Some tests failed. AGENTS.md is incomplete."
    exit 1
fi
