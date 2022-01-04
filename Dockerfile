FROM six8/pyinstaller-alpine:alpine-3.6-pyinstaller-v3.4
WORKDIR /app
COPY . .
RUN pyinstaller --onefile --noconfirm --clean ./.build/ddns.spec
RUN pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

FROM alpine:latest
LABEL maintainer="NN708"
COPY --from=0 /app/dist/ddns /
RUN echo "*/5 * * * *   /ddns -c /config.json" > /etc/crontabs/root
CMD [ "crond", "-f" ]