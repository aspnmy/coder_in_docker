# 一致性构建镜像 buildah bud --no-cache -f Dockerfile -t 容器名

FROM aspnmy/debian:base

ARG S6_OVERLAY_VERSION=3.2.0.0
# 更改主服务名称 只需在此配置变量名即可 其他服务无需理会
ARG S6_OVERLAY_SERVIES=coder
# 主服务项目PATH
ARG S6_SERVIES_PATH=/etc/s6-overlay/s6-rc.d/${S6_OVERLAY_SERVIES}

# 下面是固定的业务常量不需要修改

# S6_OVERLAY_UPDATE_URL
ARG S6_OVERLAY_UPDATE_URL=https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}

#### --构建主服务${S6_OVERLAY_SERVIES}语句-开始
# 更新软件包列表
RUN apt-get update && apt-get install -y curl git xz-utils dos2unix && curl -L https://coder.com/install.sh | sh



# 生成主服务${S6_OVERLAY_SERVIES}运行目录配置权限

# 设置初始root密码
RUN echo 'root:root@#1314' | chpasswd

#### --构建主服务${S6_OVERLAY_SERVIES}语句-结束

#### --构建超级进程服务${S6_OVERLAY_SERVIES}语句-开始-不清楚不要改
# ----安装S6_OVERLAY-github下载最新版s6-overlay 不需要更改
ADD ${S6_OVERLAY_UPDATE_URL}/s6-overlay-noarch.tar.xz /tmp
ADD ${S6_OVERLAY_UPDATE_URL}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

# s6旧版配置方式
EXPOSE 3000

# 清理缓存减小容器体积
RUN rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# 设置s6-overla:v${S6_OVERLAY_VERSION}全局的ENTRYPOINT
ENTRYPOINT ["/init"]

CMD [ "coder server"]