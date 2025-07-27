FROM felddy/foundryvtt:13

USER root
RUN mkdir -p /data && chown -R 1000:1000 /data

USER node

EXPOSE 30000
