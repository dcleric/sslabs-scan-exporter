# sslabs-scan-exporter
Tool for validating SSLabs rating for https endpoints and exposing it as a prometheus exporter. 
SSLabs site: https://www.ssllabs.com/ssltest/
Two-containers scheme is intended to be used inside Kubernetes cluster and exposing metrics to the Prometheus scraping metrics inside K8S.
domains.txt file contain domain-names and team assignment with : delimeter.
