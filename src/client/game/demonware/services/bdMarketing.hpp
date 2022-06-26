#pragma once

namespace demonware
{
	class bdMarketing final : public service
	{
	public:
		bdMarketing();

	private:
		void claim_reward_roll(service_server* server, byte_buffer* buffer) const;
		void claim_client_achievements(service_server* server, byte_buffer* buffer) const;
		void report_reward_events(service_server* server, byte_buffer* buffer) const;
	};
}
