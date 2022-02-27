FROM curlimages/curl:7.81.0


ADD attack.sh /attack.sh
ADD targets.txt /targets.txt

ENTRYPOINT ["/usr/bin/env"]

CMD ["sh", "/attack.sh"]
