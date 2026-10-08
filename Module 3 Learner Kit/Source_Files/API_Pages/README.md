# API Pagination Contract

The four `page_###.json` files are the frozen local truth for the Module Three pagination lab. Each page uses this envelope:

`page`, `pageSize`, `totalPages`, `nextPage`, `data`

The final page has `nextPage = null`. Each page contains 7 operation records, for 28 total.

For the final GitHub learner package, publish these exact page files under the course repository and set `pApiBaseUrl` to the raw-file folder pattern. Until publication, the local files are authoritative and can be inspected without an account.

Planned raw URL pattern after publication:

`https://raw.githubusercontent.com/SunnyVerseAILabs/Power-BI-Master-Series/refs/heads/main/Module%203%20Learner%20Kit/Source_Files/API_Pages/page_001.json`

The Detailed Build Guide will freeze the final live endpoint only after it is verified.
