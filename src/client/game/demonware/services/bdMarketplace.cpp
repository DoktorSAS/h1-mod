#include <std_include.hpp>
#include "../services.hpp"

namespace demonware
{
	bdMarketplace::bdMarketplace() : service(80, "bdMarketplace")
	{
		this->register_task(42, &bdMarketplace::unk42); // COD POINTS purchase ?
		// this->register_task(43, &bdMarketplace::unk43); COD POINTS purchase ?
		this->register_task(49, &bdMarketplace::unk49);
		this->register_task(60, &bdMarketplace::unk60);
		this->register_task(130, &bdMarketplace::unk130);
		this->register_task(165, &bdMarketplace::unk165);
		this->register_task(193, &bdMarketplace::unk193);
		this->register_task(232, &bdMarketplace::unk232);
	}

	void bdMarketplace::unk42(service_server* server, byte_buffer* /*buffer*/) const
	{
		// TODO:
		auto reply = server->create_reply(this->task_id());
		reply->send();
	}

	void bdMarketplace::unk49(service_server* server, byte_buffer* /*buffer*/) const
	{
		// TODO:
		auto reply = server->create_reply(this->task_id());
		reply->send();
	}

	void bdMarketplace::unk60(service_server* server, byte_buffer* /*buffer*/) const
	{
		// TODO:
		auto reply = server->create_reply(this->task_id());
		reply->send();
	}

	void bdMarketplace::unk130(service_server* server, byte_buffer* /*buffer*/) const
	{
		// TODO:
		auto reply = server->create_reply(this->task_id());
		reply->send();
	}

	void bdMarketplace::unk165(service_server* server, byte_buffer* /*buffer*/) const
	{
		// TODO:
		auto reply = server->create_reply(this->task_id());
		reply->send();
	}

	void bdMarketplace::unk193(service_server* server, byte_buffer* /*buffer*/) const
	{
		// TODO:
		auto reply = server->create_reply(this->task_id());
		reply->send();
	}

	void bdMarketplace::unk232(service_server* server, byte_buffer* /*buffer*/) const
	{
		// TODO:
		auto reply = server->create_reply(this->task_id());
		reply->send();
	}
}
