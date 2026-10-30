## Authenticate 

```
Browser --> usrname/passowrd --> Server 
```

### Session-Cookie 

支持对 *登录* 状态声明周期的管理.
```
Browser (cookie) <----  session_id  <---- Server (session)
```

### Token 

Token Server 提供 Token Validation Service. 支持移动端应用和跨设备.

```
Browser (cookie (token)) ---> token ---> Server 
```

### JWT 

JWT 通过数字签名减少了认证 `token` 的开销.

```
Token: header.payload.signature
```

### SSO

Cross-Site Login. 单点登录供应商 sso.com 提供 *CAS (CentraLAuthentication Service)*

```
Browser --> a.com --> sso.com 
 | | |                ^ ^  ^
 | | |                | |  |
 | | +--> b.com ------+ |  |
 | |                    |  |
 | +---> c.com ---------+  |
 +-------------------------+
```

### OAuth2.0

third-party access. 

browser+server: authentication code
```
browser --> a.com --> authentication server 
```

server only: client credentials
```
a.com --> authentication server
```

native app: implicit grant
```
phone --> authentication server 
```

