#pragma once

namespace demonware
{
	class bdPublisherVariables final : public service
	{
	public:
		bdPublisherVariables();

	private:
		void unk1(service_server* server, byte_buffer* buffer) const;
	};
}
