# Clash 终端代理: proxy on / off / status / auto
# auto = 检测 127.0.0.1:7897 在线才启用（新终端启动时自动执行）

function __proxy_apply
    if test "$argv[1]" = on
        set -gx http_proxy http://127.0.0.1:7897
        set -gx https_proxy http://127.0.0.1:7897
        set -gx all_proxy socks5h://127.0.0.1:7897
        set -gx no_proxy 127.0.0.1,localhost,::1
        set -gx HTTP_PROXY $http_proxy
        set -gx HTTPS_PROXY $https_proxy
        set -gx ALL_PROXY $all_proxy
        set -gx NO_PROXY $no_proxy
    else
        set -e http_proxy https_proxy all_proxy no_proxy
        set -e HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY
    end
end

function __clash_alive
    timeout 0.5 bash -c 'exec 3<>/dev/tcp/127.0.0.1/7897' 2>/dev/null
end

function proxy --description 'Clash 终端代理: on|off|status|auto'
    switch "$argv[1]"
        case on
            if __clash_alive
                __proxy_apply on
                echo (set_color green)'✔ 终端代理已启用 (127.0.0.1:7897)'(set_color normal)
            else
                echo (set_color red)'✘ Clash 不在线 (127.0.0.1:7897)，未启用'(set_color normal)
                return 1
            end
        case off
            __proxy_apply off
            echo (set_color yellow)'✘ 终端代理已关闭'(set_color normal)
        case status
            if __clash_alive
                echo (set_color green)'Clash: 127.0.0.1:7897 在线'(set_color normal)
            else
                echo (set_color red)'Clash: 127.0.0.1:7897 离线'(set_color normal)
            end
            if set -q http_proxy
                echo "当前 shell: "(set_color green)'已启用'(set_color normal)" ($http_proxy)"
            else
                echo "当前 shell: "(set_color yellow)'未启用'(set_color normal)
            end
        case auto ''
            # 静默: 在线才启用，离线则清掉可能继承自登录会话的代理变量
            if __clash_alive
                __proxy_apply on
            else
                __proxy_apply off
            end
        case '*'
            echo "用法: proxy on|off|status|auto"
            return 2
    end
end
