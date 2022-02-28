FROM python:alpine


ADD attack.sh /attack.sh
ADD pyddos.py /pyddos.py
ADD targets.txt /targets.txt

RUN pip3 install requests

ENTRYPOINT ["/usr/bin/env"]

CMD ["sh", "/attack.sh"]
