#!/bin/bash
# Claude Code on the web の環境ダイアログの Setup script 欄に貼る。
# ネットワークは Trusted（*.nixos.org を含む）。nixpkgs は flake.nix で
# channels.nixos.org の tarball を参照する（api.github.com 経由の取得は 403 になるため）。
# 計測結果は /root/setup-timing.log に出力する。
start=$(date +%s)
echo "start $(date -Is)" > /root/setup-timing.log

# --- Nix の導入（未導入のときだけ） ---
# 注意: この導入手順は新規コンテナでは未検証。sidecar で通した手順があればここを差し替える。
if ! command -v nix >/dev/null 2>&1 && [ ! -x /nix/var/nix/profiles/default/bin/nix ]; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install linux --no-confirm --init none >> /root/setup-timing.log 2>&1
fi
export PATH="/nix/var/nix/profiles/default/bin:$PATH"

cd /home/user/aidlc-plugin-chunk-sidecar-demo || cd "$(ls -d /home/*/* | head -1)"
nix develop -c true >> /root/setup-timing.log 2>&1
echo "nix develop exit=$?" >> /root/setup-timing.log

end=$(date +%s)
echo "end $(date -Is) elapsed=$((end - start))s" >> /root/setup-timing.log
exit 0
