# Smart Campus Energy Analytics Platform

A complete, production-ready full-stack web application for autonomous campus building energy management, predictive load forecasting, statistical anomaly detection, and HVAC load curtailment decision support.

**Student:** RAJA K (7376241CS335)  
**Semester:** 5 | **Department:** Information Technology  
**Project Guide:** Janani T, Assistant Professor  

---

## Quick Start (Two Commands)

### 1. Backend (FastAPI + SQLite)
```bash
cd backend
pip install -r requirements.txt
python seed.py
uvicorn main:app --reload --port 8000
```

### 2. Frontend (React + Vite + TypeScript + Tailwind)
```bash
cd frontend
npm install
npm run dev
```

---

## Access Points
- **Frontend Application:** [http://localhost:5173](http://localhost:5173)
- **Interactive Backend API Docs:** [http://localhost:8000/docs](http://localhost:8000/docs)
- **ReDoc API Specifications:** [http://localhost:8000/redoc](http://localhost:8000/redoc)

---

## Authentication & Fixed Credentials

### Admin (Facility Manager)
- **Role:** `admin`
- **Email:** `rajak.cs24@BITSATHY.AC.IN`
- **Password:** `CS335`
- **Access Route:** Direct redirect to `/admin`

### Management (College Administration / Deanery)
- **Role:** `management`
- **Email:** `management@campus.edu`
- **Password:** `RAJAK335`
- **Step 2 Verification Key:** `MGMT2026`
- **Access Route:** Redirects to `/management-signin` for 2-step verification, then grants access to `/management`

*Note: Any unauthenticated or unauthorized request is strictly blocked and redirected to `/login`.*

---

## Project Structure

```
smart-campus-energy-platform/
├── backend/
│   ├── main.py              # FastAPI server with all REST endpoints & CORS
│   ├── database.py          # SQLite schema, foreign keys & connection management
│   ├── auth.py              # JWT authentication, password hashing & route guards
│   ├── seed.py              # Seed data: 10 zones, 30 days readings, forecasts, peaks, recs
│   ├── requirements.txt     # Python dependencies
│   └── data/campus.db       # Auto-created SQLite file database
├── frontend/
│   ├── src/
│   │   ├── main.tsx         # React bootstrap
│   │   ├── App.tsx          # React Router v6, layout wrappers & role guards
│   │   ├── api.ts           # Centralized Axios client with JWT interceptor & adminApi
│   │   ├── components/
│   │   │   ├── KPICard.tsx              # Reusable metric card with accents & trends
│   │   │   ├── ChartCard.tsx            # Standard dark container for charts
│   │   │   ├── Sidebar.tsx              # Collapsible navigation with role menus
│   │   │   ├── TopBar.tsx               # Header with user avatar & BMS status
│   │   │   ├── ZoneCard.tsx             # Interactive facility telemetry card
│   │   │   ├── AddZoneModal.tsx         # Modal for provisioning buildings & generating telemetry
│   │   │   ├── DeleteZoneModal.tsx      # Safety confirmation modal for soft deletion
│   │   │   └── RecommendationCard.tsx   # Curtailment proposal with Approve/Dismiss
│   │   ├── pages/
│   │   │   ├── Login.tsx                # Role toggle login matching dashboard UI
│   │   │   ├── ManagementSignIn.tsx     # Step 2 verification page
│   │   │   ├── admin/
│   │   │   │   ├── Dashboard.tsx        # 4 KPIs, 24h curve, zone pie, top 5 table
│   │   │   │   ├── LiveMonitor.tsx      # 10 zone cards with modal inspection
│   │   │   │   ├── ZoneManagement.tsx   # Admin building onboarding, soft delete & audit logs
│   │   │   │   ├── Forecast.tsx         # 24h regression curve with 95% confidence band
│   │   │   │   ├── PeakAlerts.tsx       # Z-score peak list with severity badges
│   │   │   │   ├── Recommendations.tsx  # Interactive curtailment dispatching
│   │   │   │   └── Reports.tsx          # Telemetry & audit logs with CSV export
│   │   │   └── management/
│   │   │       ├── Dashboard.tsx        # Executive KPIs, savings bar, typology donut
│   │   │       ├── EnergyOverview.tsx   # Baseline vs actual curve & weekly heatmap
│   │   │       ├── CostAnalysis.tsx     # Avoided surcharges, cumulative savings
│   │   │       ├── Sustainability.tsx   # 84/100 score gauge, carbon abatement curve
│   │   │       └── Reports.tsx          # Executive briefing & printable PDF export
│   │   ├── index.css                    # Dark navy + electric green design system
│   │   └── vite-env.d.ts
│   ├── index.html
│   ├── package.json
│   ├── tsconfig.json
│   ├── vite.config.ts                   # Proxy to FastAPI port 8000
│   └── tailwind.config.js               # Campus palette tokens
└── README.md
```

---

## Building Zone Management (Admin Only)

The platform provides autonomous lifecycle management for campus building nodes under `/admin/zones`:
- **Add New Zone (`POST /api/admin/zones`):** Provision a new building with name, building type, occupant capacity, unique smart meter ID (`MTR-XXX-000`), sensor telemetry IDs, and floor area. Optionally generates **30 days of hourly energy readings (720 records)** and **24h predictive forecasts** with confidence bands immediately.
- **Soft Deletion (`DELETE /api/admin/zones/{id}`):** Decommissions buildings safely without data loss by setting `deleted_at = CURRENT_TIMESTAMP`. Excluded from live operational queries while retaining historical audit continuity. Requires typing the exact zone name to prevent accidental deletion.
- **Restore Zone (`POST /api/admin/zones/{id}/restore`):** Reactivates archived buildings instantly.
- **Audit Logging (`GET /api/admin/audit-logs`):** Automatically registers operator emails, action tags (`CREATE_ZONE`, `DELETE_ZONE`, `RESTORE_ZONE`), timestamps, and topological changes.
- **Role-Based Access Enforcement:** Admin-exclusive endpoints. Management role requests receive strict HTTP 403 Forbidden.

---

## Key Features & Scientific Methodology

1. **10 Campus Zones Monitored:**
   - Academic Block A (120 kW)
   - Academic Block B (95 kW)
   - Central Library (80 kW)
   - Computer Lab Complex (150 kW)
   - Electronics Lab (110 kW)
   - Administrative Office (60 kW)
   - Boys Hostel 1 (90 kW)
   - Girls Hostel 2 (85 kW)
   - Cafeteria (70 kW)
   - Auditorium (40 kW)

2. **Mathematical Curtailment & Rebound Model:**
   - **Net Energy Savings:** $E_{\text{net}} = E_{\text{gross}} \times (1 - r_{\text{rebound}})$ with $r_{\text{rebound}} = 0.30$ (30% thermal rebound).
   - **Financial Gain:** Net savings $\times$ commercial tariff rate (₹9.00/kWh).
   - **Avoided Carbon:** Net savings $\times$ grid factor ($0.67\text{ kg CO}_2/\text{kWh}$).

3. **Peak Surcharge Avoidance:**
   - Mitigates penalty surcharges by preventing aggregate peak demand from breaching the contracted 950 kVA threshold, saving ₹18,500/month.
