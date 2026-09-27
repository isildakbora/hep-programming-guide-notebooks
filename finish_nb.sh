#!/usr/bin/env bash
# Wait for the notebook jobs and the style deploy, then publish notebooks and redeploy the book with Colab links. Log: finish_nb.log
cd "$(dirname "$0")"
while pgrep -f "Colab-ready Jupyter" >/dev/null; do sleep 30; done
while pgrep -f finish_style.sh >/dev/null; do sleep 30; done
{
if python3 publish.py; then
  grep -q 'p.colab' ../build/style.css || echo '.colab{font-family:var(--f-ui);font-size:13px;margin:0 16px 10px}.colab a{font-weight:600}' >> ../build/style.css
  python3 ../build/assemble.py /Users/boraisildak/cernbox/ytu_cms_web/book/HEP_Programming_Guide.html /Users/boraisildak/cernbox/ytu_cms_web/book/cover_thumb.jpg && echo "== BOOK DEPLOYED WITH COLAB LINKS"
else
  echo "== NOT PUBLISHED (validation failed, see above)"
fi
} > finish_nb.log 2>&1
