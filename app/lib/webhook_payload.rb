# frozen_string_literal: true

module WebhookPayload
  def get_webhook_payload(outgoing_webhook, transaction)
    case outgoing_webhook.system
    when 'identity'
      identity_webhook_payload(transaction)
    else
      default_webhook_payload(transaction)
    end
  end

  def default_webhook_payload(transaction)
    {
      system: 'do_paisa',
      processor: {
        name: transaction.processor.name,
        id: transaction.processor.id
      },
      transaction: {
        id: transaction.id,
        amount: transaction.amount,
        status: transaction.status,
        recurring: transaction.recurring?
      },
      donor: {
        id: transaction.donor.id,
        metadata: transaction.donor.metadata
      }
    }
  end

  def identity_webhook_payload(transaction)
    {
      system: 'do_paisa',
      external_id: transaction.id,
      email: transaction.donor.metadata['email'],
      first_name: transaction.donor.metadata['name'].split(' ').first,
      last_name: transaction.donor.metadata['name'].split(' ')[1..-1].join(' '),
      postcode: transaction.donor.metadata['postcode'],
      country: transaction.donor.metadata['country'],
      created_at: transaction.created_at,
      amount: (transaction.amount / 100.to_f).round(2),
      card_brand: 'unknown',
      source: "#{transaction.source_external_id}|#{transaction.source_system}",
      source_system: transaction.source_system,
      source_external_id: transaction.source_external_id
    }
  end
end