#!/bin/bash

# ============================================
#              R E C O O
#   Recon Automation Toolkit
#
#   Developed by: Aabid (Ziffrit)
#   GitHub: https://github.com/Ziffrit
#
#   Purpose: Automates subdomain enumeration, live host
#   discovery, endpoint crawling, and vulnerability scanning
#   for bug bounty / VAPT recon.
# ============================================

if [ -z "$1" ]; then
    echo "Usage: $0 <target-domain>"
    echo "Example: $0 target.com"
    exit 1
fi

DOMAIN=$1
BASE="recoo_output/$DOMAIN"

# Organized folder structure
SUBS_DIR="$BASE/01_subdomains"
LIVE_DIR="$BASE/02_live_hosts"
CRAWL_DIR="$BASE/03_endpoints"
VULN_DIR="$BASE/04_vulnerabilities"

mkdir -p "$SUBS_DIR" "$LIVE_DIR" "$CRAWL_DIR" "$VULN_DIR"

echo "============================================"
echo "   RECOO - Recon Automation Toolkit"
echo "   Developed by Aabid (Ziffrit)"
echo "============================================"
echo "[*] Target: $DOMAIN"
echo "[*] Output base folder: $BASE"
echo ""

# 1. Subdomain enumeration - Subfinder
echo "[*] Step 1/5: Running Subfinder..."
subfinder -d "$DOMAIN" -silent -o "$SUBS_DIR/subfinder.txt"

# 2. Subdomain enumeration - Amass (passive)
echo "[*] Step 2/5: Running Amass (passive)..."
amass enum -passive -d "$DOMAIN" -o "$SUBS_DIR/amass.txt"

# 3. Merge and deduplicate
echo "[*] Merging and deduplicating subdomains..."
cat "$SUBS_DIR/subfinder.txt" "$SUBS_DIR/amass.txt" 2>/dev/null | sort -u > "$SUBS_DIR/all_subdomains.txt"
TOTAL=$(wc -l < "$SUBS_DIR/all_subdomains.txt")
echo "[*] Total unique subdomains found: $TOTAL"
echo ""

# 4. Probe for live hosts - httpx
echo "[*] Step 3/5: Probing live hosts with httpx..."
cat "$SUBS_DIR/all_subdomains.txt" | httpx -silent -o "$LIVE_DIR/live_hosts.txt"
LIVE=$(wc -l < "$LIVE_DIR/live_hosts.txt")
echo "[*] Live hosts found: $LIVE"
echo ""

# 5. Crawl endpoints - Katana
echo "[*] Step 4/5: Crawling endpoints with Katana..."
katana -list "$LIVE_DIR/live_hosts.txt" -silent -o "$CRAWL_DIR/endpoints.txt"

# 6. Vulnerability scan - Nuclei
echo "[*] Step 5/5: Running Nuclei vulnerability scan..."
nuclei -list "$LIVE_DIR/live_hosts.txt" -silent -o "$VULN_DIR/nuclei_results.txt"

echo ""
echo "============================================"
echo "[*] Recoo scan complete!"
echo "[*] Results organized in: $BASE/"
echo "    01_subdomains/     -> Raw + merged subdomain lists"
echo "    02_live_hosts/     -> Live/reachable hosts"
echo "    03_endpoints/      -> Crawled endpoints (Katana)"
echo "    04_vulnerabilities/-> Nuclei scan findings"
echo "============================================"
