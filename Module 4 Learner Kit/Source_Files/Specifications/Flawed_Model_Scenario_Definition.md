# Deliberately Flawed Model Scenario Definition

The learner creates the flawed state deliberately from the healthy source estate. The source pack does not ship a fake PBIX.

Required failures to reproduce and diagnose:
1. relate generation to plant by the wrong key domain;
2. load the duplicate plant variant and attempt to use the duplicated key on the one side;
3. set an unjustified Both-direction path and create ambiguity;
4. activate the wrong date role for maintenance or forecast analysis;
5. connect repeated business keys directly and create accidental many-to-many;
6. use the missing-date sample to expose date coverage failure;
7. use the orphan fact sample to expose the blank unknown-member row under a regular relationship;
8. use the five DirectQuery-style orphan rows to show why Assume referential integrity can suppress unmatched rows;
9. compare the healthy bridge design with a direct *:* shortcut;
10. remove redundant relationships and return to the healthy model.
