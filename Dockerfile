# 一致性构建镜像 buildah bud --no-cache -f Dockerfile -t 容器名


FROM aspnmy/debian-ssh:s6-overlay-v12.7

ARG ROOT_PWD=root:root@#1314
# 主服务项目名称
ARG SERVIES_NAME=coder
ARG USER_NAME=${SERVIES_NAME}user
ARG USER_PWD=${USER_NAME}:${USER_NAME}@#1314


# 下面是固定的业务常量不需要修改



#### --构建主服务${SERVIES_NAME}语句-开始
# 更新软件包列表
# 设置初始root密码
RUN echo ${ROOT_PWD} | chpasswd && useradd -m -s /bin/bash ${USER_NAME} &&  echo ${USER_PWD} | chpasswd

RUN apt-get update && apt-get install -y curl
# 切换rootless用户
# RUN su - ${USER_NAME} &&  curl -L https://coder.com/install.sh | sh && coder server

# apt-get update && apt-get install -y curl &&  curl -L https://coder.com/install.sh | sh
# s6旧版配置方式
EXPOSE 3000

# 清理缓存减小容器体积
# RUN rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# 清理缓存减小容器体积
RUN apt-get autoremove && deborphan | xargs apt-get remove --purge && apt-get autoremove --purge  && apt-get remove -y deborphan && apt-get autoclean && apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*


# 设置s6-overla:v${S6_OVERLAY_VERSION}全局的ENTRYPOINT
ENTRYPOINT ["/init"]
