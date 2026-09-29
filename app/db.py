import os

import pymysql

CONN = dict(
    host=os.environ.get("TT_DB_HOST", "127.0.0.1"),
    port=int(os.environ.get("TT_DB_PORT", "3306")),
    user=os.environ.get("TT_DB_USER", "tt_user"),
    password=os.environ.get("TT_DB_PASSWORD", ""),
    database=os.environ.get("TT_DB_NAME", "teamtrack"),
    autocommit=True,
    charset="utf8mb4",
)

ROW = pymysql.cursors.DictCursor


def get_conn():
    return pymysql.connect(**CONN)


def query(sql, args=None):
    conn = get_conn()
    try:
        with conn.cursor(ROW) as cur:
            cur.execute(sql, args)
            return cur.fetchall()
    finally:
        conn.close()


def query_one(sql, args=None):
    rows = query(sql, args)
    return rows[0] if rows else None


def execute(sql, args=None):
    conn = get_conn()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, args)
            conn.commit()
            return cur.lastrowid
    finally:
        conn.close()
