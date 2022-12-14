CREATE TABLE IF NOT EXISTS orders
(
    order_uid          TEXT PRIMARY KEY UNIQUE,
    track_number       TEXT NOT NULL,
    entry              TEXT NOT NULL,
    locale             TEXT NOT NULL,
    internal_signature TEXT NOT NULL,
    customer_id        TEXT NOT NULL,
    delivery_service   TEXT NOT NULL,
    shardkey           TEXT NOT NULL,
    sm_id              INT  NOT NULL,
    date_created       TIMESTAMPTZ NOT NULL,
    oof_shard          TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS delivery
(
    id        SERIAL PRIMARY KEY,
    name      TEXT   NOT NULL,
    phone     TEXT   NOT NULL,
    zip       TEXT   NOT NULL,
    city      TEXT   NOT NULL,
    address   TEXT   NOT NULL,
    region    TEXT   NOT NULL,
    email     TEXT   NOT NULL,
    order_uid TEXT   NOT NULL,

    FOREIGN KEY (order_uid) REFERENCES orders(order_uid) ON DELETE CASCADE 
);

CREATE TABLE IF NOT EXISTS payment
(
    id            SERIAL PRIMARY KEY,
    transaction   TEXT   NOT NULL,
    request_id    TEXT   NOT NULL,
    currency      TEXT   NOT NULL,
    provider      TEXT   NOT NULL,
    amount        INT    NOT NULL,
    payment_dt    INT    NOT NULL,
    bank          TEXT   NOT NULL,
    delivery_cost INT    NOT NULL, 
    goods_total   INT    NOT NULL,
    custom_fee    INT    NOT NULL,  
    order_uid     TEXT   NOT NULL,

    FOREIGN KEY (order_uid) REFERENCES orders(order_uid) ON DELETE CASCADE 
);

CREATE TABLE IF NOT EXISTS items
(
    id           SERIAL PRIMARY KEY,
    chrt_id      INT    NOT NULL,
    track_number TEXT   NOT NULL,
    price        INT    NOT NULL,
    rid          TEXT   NOT NULL,
    name         TEXT   NOT NULL,
    sale         INT    NOT NULL,
    size         TEXT   NOT NULL,
    total_price  INT    NOT NULL,
    nm_id        INT    NOT NULL,
    brand        TEXT   NOT NULL,
    status       INT    NOT NULL,
    order_uid    TEXT   NOT NULL,

    FOREIGN KEY (order_uid) REFERENCES orders(order_uid) ON DELETE CASCADE 
);