#!/usr/bin/env python3
"""Keep the active production deployment and its previous successful version."""
import json
import os
import sys
from urllib.parse import quote
from urllib.request import Request, urlopen


def api(url, token, method="GET"):
    request = Request(url, method=method, headers={"Authorization": f"Bearer {token}"})
    with urlopen(request, timeout=30) as response:
        result = json.load(response)
    if not result.get("success"):
        raise RuntimeError(f"Cloudflare API request failed: {result.get('errors')}")
    return result


def select_deletions(deployments, active_id):
    successful = sorted(
        (d for d in deployments if d.get("environment") == "production"
         and d.get("latest_stage", {}).get("name") == "deploy"
         and d.get("latest_stage", {}).get("status") == "success"),
        key=lambda d: d["created_on"], reverse=True,
    )
    if not successful or successful[0]["id"] != active_id:
        raise ValueError("Active production deployment is not the newest successful deployment; refusing cleanup")
    keep = {d["id"] for d in successful[:2]}
    return [d for d in deployments if d.get("environment") == "production" and d["id"] not in keep
            and d.get("latest_stage", {}).get("status") not in ("active", "idle")]


def main():
    account = os.environ["CLOUDFLARE_ACCOUNT_ID"]
    project = os.environ["CLOUDFLARE_PAGES_PROJECT"]
    token = os.environ["CLOUDFLARE_API_TOKEN"]
    base = f"https://api.cloudflare.com/client/v4/accounts/{quote(account, safe='')}/pages/projects/{quote(project, safe='')}"
    project_data = api(base, token)["result"]
    active_id = (project_data.get("canonical_deployment") or {}).get("id")
    if not active_id:
        raise ValueError("Cannot determine active production deployment")
    deployments = []
    page = 1
    while True:
        result = api(f"{base}/deployments?env=production&per_page=100&page={page}", token)
        deployments.extend(result["result"])
        if page >= result["result_info"]["total_pages"]:
            break
        page += 1
    for deployment in select_deletions(deployments, active_id):
        deployment_id = deployment["id"]
        print(f"Deleting old production deployment {deployment_id}", flush=True)
        api(f"{base}/deployments/{quote(deployment_id, safe='')}", token, "DELETE")


if __name__ == "__main__":
    try:
        main()
    except (OSError, KeyError, ValueError, RuntimeError) as error:
        print(f"Deployment cleanup failed: {error}", file=sys.stderr)
        sys.exit(1)
