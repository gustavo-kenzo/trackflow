CREATE TABLE categories
(
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id         BIGINT      NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    name            VARCHAR(60) NOT NULL,
    normalized_name VARCHAR(60) NOT NULL,
    color           VARCHAR(7),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT categories_id_user_id_uk UNIQUE (id, user_id),
    CONSTRAINT categories_user_id_normalized_name_uk UNIQUE (user_id, normalized_name),
    CONSTRAINT categories_color_fmt_ck CHECK (color IS NULL OR color ~ '^#[0-9A-Fa-f]{6}$')
);
