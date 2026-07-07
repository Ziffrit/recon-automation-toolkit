# Recoo 🔍

**Recon Automation Toolkit** — automates subdomain enumeration, live host discovery, endpoint crawling, and vulnerability scanning for bug bounty / VAPT engagements.

**Developed by:** Aabid ([@Ziffrit](https://github.com/Ziffrit))

---

## What it does

Recoo runs a full recon pipeline in one command:

1. **Subdomain Enumeration** — Subfinder + Amass (passive)
2. **Merge & Deduplicate** — combines results into one clean list
3. **Live Host Detection** — httpx probes for reachable hosts
4. **Endpoint Crawling** — Katana crawls live hosts for endpoints
5. **Vulnerability Scanning** — Nuclei scans for known issues/misconfigurations

## Output Structure

Results are neatly organized per target:

```
recoo_output/
└── target.com/
    ├── 01_subdomains/
    │   ├── subfinder.txt
    │   ├── amass.txt
    │   └── all_subdomains.txt
    ├── 02_live_hosts/
    │   └── live_hosts.txt
    ├── 03_endpoints/
    │   └── endpoints.txt
    └── 04_vulnerabilities/
        └── nuclei_results.txt
```

## Tools Used

- [Subfinder](https://github.com/projectdiscovery/subfinder)
- [Amass](https://github.com/owasp-amass/amass)
- [httpx](https://github.com/projectdiscovery/httpx)
- [Katana](https://github.com/projectdiscovery/katana)
- [Nuclei](https://github.com/projectdiscovery/nuclei)

## Requirements

```bash
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
```

Amass on Kali Linux:
```bash
sudo apt install amass
```

## Usage

```bash
chmod +x recoo.sh
./recoo.sh target.com
```

## Disclaimer

Recoo is intended for **authorized security testing** and bug bounty programs only. Always ensure you have explicit permission to test a target before scanning it.

---

*Built as part of ongoing bug bounty / VAPT practice by Aabid.*
