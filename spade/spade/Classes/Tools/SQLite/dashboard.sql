CREATE TABLE IF NOT EXISTS "T_dashboard" (
    "id" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "dashboard" TEXT,
    "createTime" TEXT DEFAULT (datetime('now', 'localtime')) ,
    PRIMARY KEY("id","userId")
);
