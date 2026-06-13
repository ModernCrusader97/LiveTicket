QA Checklist - LiveTicket Admin Concert Features

1) Build & Start
- [ ] mvn -U clean package
- [ ] mvn spring-boot:run
- Expected: Application starts without errors. Check logs for startup exceptions.

2) Authentication / Authorization
- [ ] Admin-only paths (/admin/**) are blocked for non-logged-in users.
- [ ] Admin-only paths are blocked for logged-in users with authLevel < 7.
- [ ] Admin with authLevel >= 7 can access admin pages.

3) Concert Create
- [ ] Create page loads (/admin/concert/create).
- [ ] Poster upload accepted and saved to configured folder.
- [ ] New artists (with images) are preserved and submitted.
- [ ] Schedules JSON is parsed and child concerts created.

4) Concert Edit / Update
- [ ] Edit page loads and displays current concert data.
- [ ] Poster replacement updates stored poster file.
- [ ] Status change works (DRAFT/OPEN/PAUSED/CLOSED).
- [ ] Seat structure change constraints:
    - [ ] If confirmed reservations exist, seat structure change is blocked.
    - [ ] If concert status == OPEN, seat structure change is blocked.
    - [ ] If allowed, previous seats are deleted and new seats inserted.

5) Seat Matrix Preview (create.jsp)
- [ ] Row and column controls display correct labels.
- [ ] Clicking seat toggles blocked/available states.
- [ ] Row/column toggles function.

6) Reservation Safety
- [ ] PENDING -> RESERVED flows still work.
- [ ] Confirmed seats prevent structure modifications.

7) Data Integrity
- [ ] After changes, seat counts and remaining seats reflect DB state.
- [ ] Sales stats (revenue / reservedCount) show accurate sums.

8) UI/UX
- [ ] Forms validate required fields (title, poster on create if required).
- [ ] Helpful messages on failure (alerts shown to admin).

9) Logging & Error Handling
- [ ] Exceptions are logged with stack traces in server logs.
- [ ] User-facing errors show actionable messages.

10) Regression Tests (Automated)
- [ ] Unit tests for ConcertAdminService: status change, blocking logic for seat changes.
- [ ] Integration test for admin endpoints (optional).

Notes:
- For production, migrate authLevel to role table and apply RBAC.
- Consider soft-delete / migration strategy for seat changes to allow rollback.

Running tests:
- mvn test

If any step fails, collect the server logs (target/surefire-reports for test failures and application logs) and provide stack traces.