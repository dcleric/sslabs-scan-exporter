FROM alpine:3.4

RUN apk --no-cache add bash ca-certificates

COPY sslcheck /sslcheck 
COPY ssllabs-scan ./sslcheck/
RUN chmod u+x /sslcheck/check_host.sh && chmod u+x /sslcheck/ssllabs-scan

CMD ["/sslcheck/check_host.sh"]
