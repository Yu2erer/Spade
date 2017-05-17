CREATE TABLE IF NOT EXISTS "T_dashboard" (
    "id" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "dashboard" TEXT,
    PRIMARY KEY("id","userId")
);
