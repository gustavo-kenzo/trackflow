package com.gustavo.trackflow;

import com.gustavo.trackflow.testcontainers.AbstractTestContainers;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
class TrackflowApplicationTests extends AbstractTestContainers {

	@Test
	void contextLoads() {
	}

}
