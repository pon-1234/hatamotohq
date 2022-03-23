# frozen_string_literal: true

json.(client, :id, :name, :created_at, :status)
json.line_name client.line_account&.line_name
json.admin_email client.admin&.email
