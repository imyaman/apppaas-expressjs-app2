// Shared runtime status, surfaced by the /status endpoint for remote diagnosis.
export const status = {
  init: 'pending',      // pending | ok | failed
  initError: null,
  initDetail: null,     // e.g. "seafile_db: 46 tables"
  seaf: 'pending',      // pending | running | failed
  seafPid: null,
  seafError: null,
};
