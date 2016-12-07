# HA LB with docker keepalived and docker haproxy

##features
1. keepalived check if haproxy works on 127.0.0.1:60001(http check, status code 200) locally
2. if dont't keepalived starts haproxy process

All checks should be http checks
Check for https api backend is l4, because i don't wont terminate ssl on lb

docs: https://www.linangran.com/?p=547
