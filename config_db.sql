-- These are carlo von lynX's proposed defaults for the
-- configuration of a new Liquid Feedback instance. They
-- build upon eight years of experience and reasoning on
-- the methods of liquid democracy. Further explanations
-- are being provided on http://structure.pages.de

-- Use of LQFB for non-binding surveys rather than actual
-- decisions is not recommended, neither by the developers
-- nor by me. Still, this is the least worst software also
-- for that purpose, so if you insist on wanting to do just
-- online surveys, you may need different units and policies.
--
-- This default configuration however is for using LQFB as a
-- binding decision-making tool, virtualizing multiple legal
-- and organizational bodies. First, let's introduce the juice
-- of LQFB, the policies that define how democracy works.


--=== Section One: POLICIES ===--

-- Qualified majority voting policies:
--	These have a traditional predictable deadline for the debate to
--	end and pass into voting. If you really have externally imposed
--	deadlines you should use 'polling' method instead. This is a
--	halfway in-between consensus seeking and polling, which may in
--	fact be suboptimal for either use case.
--
INSERT INTO policy (index, name, description, min_admission_time, max_admission_time, discussion_time, verification_time, voting_time, issue_quorum_num, issue_quorum_den, initiative_quorum_num, initiative_quorum_den, direct_majority_num, direct_majority_den, indirect_majority_num, indirect_majority_den) VALUES (1, 'Regular Motion', 'Prolonged debate leading to a final vote after a predictable time period.', '1 hour', '7 days', '60 days', '2 days', '7 days', 20, 100, 20, 100, 2, 3, 1, 2);
INSERT INTO policy (index, name, description, min_admission_time, max_admission_time, discussion_time, verification_time, voting_time, issue_quorum_num, issue_quorum_den, initiative_quorum_num, initiative_quorum_den, direct_majority_num, direct_majority_den, indirect_majority_num, indirect_majority_den) VALUES (2, 'Urgent Motion', 'Have a quick vote on an urgent matter.', '1 hour', '4 days', '1 day', '1 day', '1 day', 30, 100, 30, 100, 80, 100, 1, 2);

-- Consensus policies:
--	These debates are given all the time in the world until they
--	reach the needed consensus - which may very well be never, which
--	means that the measurement of consensus remains available some-
--	where deep in the database for anyone who needs it (as a proof
--	that a certain topic is not of interest, for example). Once
--	consensus is reached, however, the debate is immediately frozen.
--	No use for extra debate that might actually reduce consensus.
--      Here too, verification time is given to protect against trickery
--      until we move to final ratification. Indirect majority (among
--      concurring consensus proposals) is considered unimportant
--      compared to having a winning consensus.
-- FIXME: LQFB could have improved support for consensus-oriented policies.
--
INSERT INTO policy (index, name, description, min_admission_time, max_admission_time, discussion_time, verification_time, voting_time, issue_quorum_num, issue_quorum_den, initiative_quorum_num, initiative_quorum_den, direct_majority_num, direct_majority_den, indirect_majority_num, indirect_majority_den) VALUES (3, 'Patient Consensus', 'Have an undetermined amount of time for a search of consensus.', '1 hour', '1 year', '0 days', '2 days', '7 days', 80, 100, 70, 100, 80, 100, 10, 100);
INSERT INTO policy (index, name, description, min_admission_time, max_admission_time, discussion_time, verification_time, voting_time, issue_quorum_num, issue_quorum_den, initiative_quorum_num, initiative_quorum_den, direct_majority_num, direct_majority_den, indirect_majority_num, indirect_majority_den) VALUES (4, 'Quick Consensus', 'See if we can quickly reach a consensus to work with.', '1 hour', '7 days', '0 days', '12 hours', '1 day', 80, 100, 70, 100, 80, 100, 10, 100);

-- This is a consensus evaluation policy intended to never enter voting phase.
-- Worst case it just hangs around in the database unattended.
INSERT INTO policy (index, name, description, min_admission_time, max_admission_time, discussion_time, verification_time, voting_time, issue_quorum_num, issue_quorum_den, initiative_quorum_num, initiative_quorum_den, direct_majority_num, direct_majority_den, indirect_majority_num, indirect_majority_den) VALUES (5, 'Ongoing Evaluation', 'Have an undetermined evaluation of consensus without final ratification.', '1000 years', '1000 years', '0 days', '0 days', '0 days', 101, 100, 101, 100, 101, 100, 101, 100);

-- We do not provide simple majority voting policies for the Assembly
-- as they have terrible consequences for the social cohesion of the
-- group. This is (the only) conscious disagreement with the developers
-- of Liquid Feedback who recommend simple majority because otherwise
-- the "status quo" would be advantaged. We have experienced that it is
-- a far lesser problem to give the status quo a strategic advantage
-- than it is to heal the wounds of a group split in two over a dispute.
-- Instead we define them just for executive and small group voting.
-- In this case we only want clear winners and accept no Condorcet
-- paradoxons, therefore no_reverse_beat_path and no_multistage_majority.
--
-- Simple majority voting policies:

INSERT INTO policy (index, name, description, min_admission_time, max_admission_time, discussion_time, verification_time, voting_time, issue_quorum_num, issue_quorum_den, initiative_quorum_num, initiative_quorum_den, direct_majority_num, direct_majority_den, indirect_majority_num, indirect_majority_den, no_reverse_beat_path, no_multistage_majority) VALUES (6, 'Regular Majority', 'Simple majority decisions for executive or judicial branches.', '1 hour', '7 days', '4 days', '8 hours', '1 day', 20, 100, 20, 100, 50, 100, 10, 100, TRUE, TRUE);
INSERT INTO policy (index, name, description, min_admission_time, max_admission_time, discussion_time, verification_time, voting_time, issue_quorum_num, issue_quorum_den, initiative_quorum_num, initiative_quorum_den, direct_majority_num, direct_majority_den, indirect_majority_num, indirect_majority_den, no_reverse_beat_path, no_multistage_majority) VALUES (7, 'Urgent Majority', 'Simple majority executive or judicial decisions on an urgent matter.', '1 hour', '4 days', '1 day', '4 hours', '1 day', 30, 100, 30, 100, 50, 100, 10, 100, TRUE, TRUE);


--=== Section Two: UNITS ===--

-- You may want to use LQFB for multiple groups of people.
-- This configuration only defines one such group.
--
INSERT INTO unit (id, parent_id, name, external_reference, description) VALUES (1, NULL, 'Our Group', 'https://structure.pages.de', 'Welcome to Liquid Feedback in carlo von lynX''s configuration, whoever you are. You should describe your group or organization here.');

-- The Integrity Council has to be manually populated with
-- those members of the Assembly that got elected to have
-- this extra role. Since its rulings are fully transparent,
-- their evolution and conclusion can be implemented within
-- LQFB themselves. The VC or IC is hereby defined as a
-- sub-unit of the unit containing everyone.
--
INSERT INTO unit (id, parent_id, name, description) VALUES (2, 1, 'Validating Council', 'The Validating Council is an elected judicial body of the organization that checks the legal integrity of Assembly decisions, to ensure that demagogic or confused proposals cannot trick the Assembly into voting inconsistently with previous choices.');
--
-- Typical use of further sub-units is to define topological
-- subgroups such as regions, nations, continents. But does it
-- actually make sense if regions take inconsistent decisions?
-- Should they better explain their local requirements to the
-- entirety of the Assembly, enabling it to decide while taking
-- their needs well in consideration?


--=== Section Three: AREAS ===--

-- This area should be used to collectively define further areas
-- like "Education", "Infrastructure", "Sustainability" etc.
-- Consider that some topics are so all-encompassing that they
-- should rather NOT have a dedicated area, as in the case of
-- Economy, Democracy and Digitalization/Technology.
--
INSERT INTO area (id, unit_id, name, description) VALUES (1, 1, 'Assembly Foundation', 'This is the foundational area of the Permanent Assembly. Here we decide on changes to the Statutes, the Manifesto and the further Configuration of this consensus-seeking platform.');
-- We only allow high consensus policies for foundational decisions.
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (1, 3, TRUE);
-- Even urgent ones, if almost everybody agrees.
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (1, 4, FALSE);

-- Here's a place to try things out. It can have all the policies.
INSERT INTO area (id, unit_id, name, description) VALUES (2, 1, 'Sandbox', 'This is a place to try out how Liquid Fedback works.');
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (2, 1, TRUE);
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (2, 2, FALSE);
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (2, 3, FALSE);
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (2, 4, FALSE);
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (2, 5, FALSE);
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (2, 6, FALSE);
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (2, 7, FALSE);

-- Executive subgroups have the extra requirement that everyone
-- who chooses to participate should be obliged to delegate as
-- they need to be able to take decisions also when people are
-- inactive. In the case of the Virtual Board the liquid
-- democratic modelling is foundational for it to be virtualizable.
-- FIXME: LQFB should have a per-area option for mandatory delegations.
--
INSERT INTO area (id, unit_id, name, description) VALUES (3, 1, 'Administration', 'This is the Virtual Board meeting. Here is where you can partake in everyday administrational decisions, if you like. You should be obliged to delegate here so that decisions can be taken also when you have no time to participate. Also, to improve the democratic representivity of the Virtual Board.');
-- Unfortunately high disagreement on how to make everyday decisions
-- is frequent, so the simple majority method comes into play:
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (3, 6, TRUE);
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (3, 7, FALSE);

INSERT INTO area (id, unit_id, name, description) VALUES (4, 1, 'Editorial Office', 'This is where your most talented writers should be empowered to work on press releases and other publications. You can choose to take part, but you should be obliged to delegate so that decisions can be taken also when you have no time to participate.');
-- The Editorial Office must output texts that are in line with
-- Assembly decisions, therefore it is reasonable to expect large
-- consensus. Advantage: if the consensus comes about quickly, we
-- don't lose much time for ratification.
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (4, 3, FALSE);
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (4, 4, TRUE);
-- Notice how the 'Editorial Office' needs no authority to decide
-- who is a competent journalist. The delegations will do so.

INSERT INTO area (id, unit_id, name, description) VALUES (5, 1, 'Art Direction', 'To ensure that the artistic output of your group is professional, high consensus among the participants of this group is required. You can choose to take part, but you should be obliged to delegate so that decisions can be taken also when you have no time to participate. Degustibus disputandum est, so the Assembly may be consulted on questions of taste and choice among proposals that have first passed the quality assurance vote of the Art Direction.');
-- Similar requirements as for the Editorial Office: here we
-- quickly agree if something is in accordance with our artistic
-- quality standards. If not, we have as much time as it takes
-- to fix it.
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (5, 3, FALSE);
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (5, 4, TRUE);
-- Notice how the 'Art Direction' needs no authority to decide
-- who is a competent art directrice or director.

-- Here's the working area for the VC (or IC).
-- Done quickly, not sure if the chosen defaults are good.
INSERT INTO area (id, unit_id, name, description) VALUES (6, 2, 'Integrity Ruling', 'This is where the Validating Council votes on interpretation and consistency of previous Assembly decisions. Only elected members of the Validating Council participate here.');
-- Unfortunately high disagreement on how to make everyday decisions
-- is frequent, so the simple majority method comes into play:
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (6, 6, FALSE);
INSERT INTO allowed_policy (area_id, policy_id, default_policy) VALUES (6, 7, TRUE);


--=== Section Four: SYSTEM SETTINGS ===--

-- Mandatory user participation interval
INSERT INTO system_setting (member_ttl) VALUES ('2 months');

-- Flooding protection, left as suggested by the developers
INSERT INTO contingent (polling, time_frame, text_entry_limit, initiative_limit) VALUES (false, '1 hour', 20, 6);
INSERT INTO contingent (polling, time_frame, text_entry_limit, initiative_limit) VALUES (false, '1 day', 80, 12);
INSERT INTO contingent (polling, time_frame, text_entry_limit, initiative_limit) VALUES (true, '1 hour', 200, 60);
INSERT INTO contingent (polling, time_frame, text_entry_limit, initiative_limit) VALUES (true, '1 day', 800, 120);

-- Generate "admin" account. You can use the web interface to
-- change its name and password. The default password is empty!
--
INSERT INTO member (activated, last_activity, active, login, name, admin, password) VALUES ('now', 'now', TRUE, 'admin', 'Please rename this to the actual Adminstrator (No anonymous admins please!)', TRUE, '$1$/EMPTY/$NEWt7XJg2efKwPm4vectc1');

-- Further structural bodies may have special requirements
-- of confidentiality which cannot be provided in the same
-- instance of LQFB as the Assembly. In fact they should
-- be implemented with separate LQFB's run by independent
-- system administration to avoid sysadmins achieving too
-- much overall knowledge. Examples:
--
-- Coordinating Group:
--	Needs to be able to discuss strategic information
--	which cannot be shared with the Virtual Board (see
--	below), but can then be informally passed to
--	influential people in order to influence the
--	choices of the Virtual Board - this way ensuring
--	that the Coordinating Group doesn't degenerate
--	into a traditional executive board.

-- Yet other bodies have entirely different needs that do
-- not fit LQFB so well. Examples:
--
-- Moderation & Court of Arbitration:
--	Both of these roles need to work with private
--	information about participants in the group that
--	cannot be disclosed to the Assembly or general
--	public, but they need to share this information
--	as the CoA needs to do ongoing monitoring of
--	justice in the actions of the Moderators. Still,
--	the CoA needs further privacy, isolated from the
--	Moderators. LQFB is currently not an ideal tool
--	to model these privacy requirements.

