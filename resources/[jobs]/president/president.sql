--
-- President script en WIP By Edwyn

--
-- Structure de la table `president`
--

CREATE TABLE `president` (
  `identifier` varchar(255) NOT NULL,
  `rankpres` varchar(255) NOT NULL DEFAULT 'President'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `president`
  ADD PRIMARY KEY (`identifier`);
