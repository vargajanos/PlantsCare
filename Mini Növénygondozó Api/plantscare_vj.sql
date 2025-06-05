-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2025. Jún 05. 11:20
-- Kiszolgáló verziója: 10.4.28-MariaDB
-- PHP verzió: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `plantscare_vj`
--
CREATE DATABASE IF NOT EXISTS `plantscare_vj` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `plantscare_vj`;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `plants`
--

CREATE TABLE `plants` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `species` varchar(100) NOT NULL,
  `water_interval_days` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `plants`
--

INSERT INTO `plants` (`id`, `name`, `species`, `water_interval_days`) VALUES
(1, 'Muskátli', 'virág', 3),
(2, 'Kaktusz', 'virág', 5),
(4, 'fiam', 'virág', 7),
(5, 'afaf', 'f', 2);

-- --------------------------------------------------------

--
-- A nézet helyettes szerkezete `statistics`
-- (Lásd alább az aktuális nézetet)
--
CREATE TABLE `statistics` (
`plant_id` int(11)
,`plant_name` varchar(100)
,`species` varchar(100)
,`watering_count` bigint(21)
,`last_watered_date` date
,`average_amount_ml` decimal(14,4)
,`total_watered_ml` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `watering_logs`
--

CREATE TABLE `watering_logs` (
  `id` int(11) NOT NULL,
  `plant_id` int(11) NOT NULL,
  `date_watered` date NOT NULL,
  `amount_ml` int(11) NOT NULL,
  `notes` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `watering_logs`
--

INSERT INTO `watering_logs` (`id`, `plant_id`, `date_watered`, `amount_ml`, `notes`) VALUES
(1, 2, '2025-06-12', 100, 'This is a note'),
(2, 1, '2025-06-16', 250, 'this is another note');

-- --------------------------------------------------------

--
-- Nézet szerkezete `statistics`
--
DROP TABLE IF EXISTS `statistics`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `statistics`  AS SELECT `p`.`id` AS `plant_id`, `p`.`name` AS `plant_name`, `p`.`species` AS `species`, count(`w`.`id`) AS `watering_count`, max(`w`.`date_watered`) AS `last_watered_date`, avg(`w`.`amount_ml`) AS `average_amount_ml`, sum(`w`.`amount_ml`) AS `total_watered_ml` FROM (`plants` `p` left join `watering_logs` `w` on(`p`.`id` = `w`.`plant_id`)) GROUP BY `p`.`id`, `p`.`name`, `p`.`species` ;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `plants`
--
ALTER TABLE `plants`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `watering_logs`
--
ALTER TABLE `watering_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plant_id` (`plant_id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `plants`
--
ALTER TABLE `plants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT a táblához `watering_logs`
--
ALTER TABLE `watering_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `watering_logs`
--
ALTER TABLE `watering_logs`
  ADD CONSTRAINT `watering_logs_ibfk_1` FOREIGN KEY (`plant_id`) REFERENCES `plants` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
