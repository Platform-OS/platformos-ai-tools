# LLM Response Examples: Good vs Comprehensive

This document shows how LLMs should respond to schema questions using AGENTS.md.

---

## Example: File Upload Question

**User Question:** "How do I upload a file?"

---

### ❌ Incomplete Response (From Example)

> Use the `create_presigned_url(input: PresignUrlInput!)` mutation to get a presigned upload URL, then upload your file to that URL. The input accepts `name`, `content_length`, `expires_in`, `acl`, and `content_disposition`. After upload, reference the file using the returned URL.
>
> For images specifically, use `image_presign_url(input: ImagePresignUrlInput!)` mutation which supports versioning options.

**Problems:**
- Missing: All mutation parameters
- Missing: Response structure
- Missing: Complete workflow
- Missing: Alternative approaches
- Missing: Related types

---

### ✓ Comprehensive Response

**Thinking process (internal):**
1. Find `UPLOAD_OPS` in COMMON_PATTERNS - lists all upload operations
2. Find `create_presigned_url` in MUTATION - shows parameters
3. Find `PresignUrlInput` in INPUTS|CREATE - shows all input fields
4. Find `PresignedUrl` in OBJECTS|ADMIN - shows response
5. Find `image_presign_url` for image-specific workflow
6. Check `PropertyUpload` for property-based uploads

**Response to user:**

```
## File Upload Options

There are **5 ways** to upload files:

### 1. Presigned URL (Recommended for large files)

**Mutation:**
```graphql
mutation {
  create_presigned_url(input: PresignUrlInput!) {
    url
    fields
  }
}
```

**Input (PresignUrlInput):**
- `name` - filename
- `acl` - private or public
- `content_disposition` - attachment or inline
- `content_length` - file size limit
- `expires_in` - URL expiration seconds
- `max_file_size` - maximum size

**Response (PresignedUrl):**
- `url` - upload endpoint
- `fields` - AWS S3 form fields

**Workflow:**
1. Call `create_presigned_url` with file metadata
2. Receive URL + fields
3. POST file to URL with fields as form data
4. File available at returned URL

---

### 2. Image Upload (With versioning)

**Mutation:**
```graphql
mutation {
  image_presign_url(input: ImagePresignUrlInput!) {
    upload_url
    upload_url_payload
  }
}
```

**Input (ImagePresignUrlInput):**
- `content_length` - max file size
- `model_property` - model schema + property
- `user_property` - user property name
- `versions` - version configuration

**Response:**
- `upload_url` - presigned S3 URL
- `upload_url_payload` - form data

---

### 3. Property Upload (For custom properties)

**Mutation:**
```graphql
mutation {
  property_upload(name: "avatar", expires_in: 3600) {
    url
    file_name
    extension
    versions {
      large { url }
      medium { url }
      thumb { url }
    }
  }
}
```

**Parameters:**
- `name` - property name
- `expires_in` - URL lifetime in seconds

**Response (PropertyUpload):**
- `url` - upload URL
- `file_name`, `extension`
- `versions` - image variants
- `error_message`, `status`
- `created_at`, `updated_at`, `expires_at`

---

### 4. Direct Image Upload

**Mutations:**
```graphql
upload_image(input: ImageInputType!)
upload_images(input: [ImageInputType!]!)
```

**Input (ImageInputType):**
- `image` - base64 or URL
- `name` - filename
- `direct_url` - or remote URL
- `remote_image_url`

---

### 5. Attachment Upload

**Mutation:**
```graphql
attachment_presign_url(input: AttachmentPresignUrlInput!)
```

**Input (AttachmentPresignUrlInput):**
- `content_disposition` - download or inline
- `content_length` - file size
- `model_property` - for models
- `user_property` - for users

---

## Quick Reference

| Method | Use Case | Returns |
|--------|----------|---------|
| `create_presigned_url` | General files | URL + fields |
| `image_presign_url` | Images with versions | URL + payload |
| `property_upload` | User/model properties | URL + versions |
| `upload_image` | Direct upload | Image type |
| `attachment_presign_url` | Attachments | URL + payload |

## Related Types

- `PresignedUrl{url, fields}` - General presigned URL
- `ImagePresignedUploadUrl{upload_url, upload_url_payload}`
- `PropertyUpload{url, file_name, extension, versions, status}`
- `AttachmentPresignedUploadUrl{upload_url, upload_url_payload}`
- `Asset{content_type, file_size, url, name}` - Stored file

## Upload Options Input Types

| Input Type | Purpose |
|------------|---------|
| `PresignUrlInput` | General file upload settings |
| `ImagePresignUrlInput` | Image upload with versions |
| `AttachmentPresignUrlInput` | Attachment settings |
| `PropertyUploadOptionsInput` | Configure ACL, encryption, resize |
| `PropertyUploadResizeInput` | Resize settings |
| `PropertyUploadVersionInput` | Version configuration |

**Note:** For implementation details (file size limits, allowed formats), reference `schema.json`.
```

---

## Key Differences

| Aspect | Incomplete | Comprehensive |
|--------|------------|---------------|
| Operations | 1 mentioned | 5 listed |
| Input fields | Partial | All fields |
| Response structure | Missing | Complete |
| Workflow steps | Missing | Step-by-step |
| Related types | Missing | Cross-referenced |
| Quick reference | Missing | Table format |
| Note on limits | Missing | References schema.json |

---

## LLM Guidance

When answering schema questions:

1. **List ALL relevant operations** - Don't mention just one
2. **Show complete input/output** - Not partial
3. **Include workflow steps** - How to use each
4. **Cross-reference types** - Related types matter
5. **Add quick reference** - Summary tables help
6. **Note what schema.json provides** - Limits, defaults, exact types

---

## Reference: Upload Operations in AGENTS.md

```
|UPLOAD_OPS|
property_upload(name,expires_in):PropertyUpload,
create_presigned_url(input):PresignedUrl,
image_presign_url(input):ImagePresignedUploadUrl,
attachment_presign_url(input):AttachmentPresignedUploadUrl,
property_upload_presigned_url(input):PropertyUploadPresignedUrl
```

```
|CREATE|
PresignUrlInput{acl,content_disposition,content_length,expires_in,max_file_size,name}
ImagePresignUrlInput{content_length,model_property,user_property,versions}
AttachmentPresignUrlInput{content_disposition,content_length,model_property,user_property}
PropertyUploadOptionsInput{acl,content_disposition,encryption,manipulate,max_file_size,output,resize,versions}
PropertyUploadResizeInput{fit,height,width}
PropertyUploadVersionInput{prefix,suffix}
```

```
|OBJECTS|ADMIN|
PresignedUrl{fields,url}
PropertyUpload{created_at,error_message,expires_at,file_name,id,status,updated_at,url,versions}
PresignedUploadUrl{upload_url,upload_url_payload}
```

---

## Template for Comprehensive Responses

```
## [Topic]

### Overview
[Brief description]

### [Option 1]
**Mutation:** `operation(params)`
**Input:** `InputType{fields}`
**Response:** `OutputType{fields}`
**Workflow:**
1. Step one
2. Step two
3. ...

### [Option 2]
...same format...

### [Option 3]
...same format...

### Quick Reference
| Method | Use Case | Returns |
|--------|----------|---------|
| op1 | case1 | type1 |
| op2 | case2 | type2 |

### Related Types
- `Type1{fields}` - purpose
- `Type2{fields}` - purpose

### Notes
- Note about limits or defaults
- Reference schema.json for exact types
```
