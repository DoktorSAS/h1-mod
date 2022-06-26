#include <std_include.hpp>
#include "../services.hpp"

namespace demonware
{
	bdMarketing::bdMarketing() : service(139, "bdMarketing") // maybe bdReward?
	{
		this->register_task(2, &bdMarketing::claim_reward_roll);
		this->register_task(3, &bdMarketing::claim_client_achievements);
		this->register_task(4, &bdMarketing::report_reward_events);
	}

	void bdMarketing::claim_reward_roll(service_server* server, byte_buffer* /*buffer*/) const
	{
		// TODO:
		auto reply = server->create_reply(this->task_id());
		reply->send();
	}

	void bdMarketing::claim_client_achievements(service_server* server, byte_buffer* /*buffer*/) const
	{
		// TODO:
		auto reply = server->create_reply(this->task_id());
		reply->send();
	}

	void bdMarketing::report_reward_events(service_server* server, byte_buffer* /*buffer*/) const
	{
		// TODO:
		auto reply = server->create_reply(this->task_id());
		reply->send();
	}
}
