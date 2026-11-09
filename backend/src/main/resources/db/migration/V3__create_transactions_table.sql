CREATE TABLE transactions
(
    id                     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id                BIGINT         NOT NULL,
    category_id            BIGINT,
    amount                 NUMERIC(11, 2) NOT NULL,
    transaction_date       DATE           NOT NULL,
    description            VARCHAR(255)   NOT NULL,
    normalized_description VARCHAR(255)   NOT NULL,
    reason_exclude         VARCHAR(60),
    created_at             TIMESTAMPTZ    NOT NULL DEFAULT now(),

    CONSTRAINT transactions_user_id_fk FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE,
    CONSTRAINT transactions_user_category_fk FOREIGN KEY (user_id, category_id) REFERENCES categories (user_id, id)
        ON DELETE SET NULL (category_id),

    CONSTRAINT transactions_reason_exclude_enum_ck CHECK (reason_exclude IN ('OWN_TRANSFERS', 'OTHER')),
    CONSTRAINT transactions_amount_valid_ck CHECK (amount <> 0)
);

CREATE INDEX transactions_user_id_transaction_date_idx ON transactions (user_id, transaction_date);
CREATE INDEX transactions_user_id_category_id_idx ON transactions (user_id, category_id);
CREATE INDEX transactions_user_id_normalized_description_idx ON transactions (user_id, normalized_description);

