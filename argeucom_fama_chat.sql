-- phpMyAdmin SQL Dump
-- version 4.7.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Tempo de geração: 03/02/2018 às 12:18
-- Versão do servidor: 5.5.58-cll
-- Versão do PHP: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `argeucom_fama_chat`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `chat_rooms`
--

CREATE TABLE `chat_rooms` (
  `chat_room_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Fazendo dump de dados para tabela `chat_rooms`
--

INSERT INTO `chat_rooms` (`chat_room_id`, `name`, `created_at`) VALUES
(1, 'Material Design', '2016-01-06 06:57:40'),
(2, 'Android Snackbar', '2016-01-06 09:57:40'),
(3, 'Google Cloud Messaging', '2016-01-06 09:57:40'),
(4, 'Android Marshmallow', '2016-01-06 09:57:40'),
(5, 'Wallpapers App', '2016-01-06 09:57:40'),
(6, 'Android Support Design Library', '2016-01-06 09:58:46'),
(7, 'Android Studio', '2016-01-06 09:58:46'),
(8, 'Realtime Chat App', '2016-01-06 09:58:46');

-- --------------------------------------------------------

--
-- Estrutura para tabela `chat_room_messages`
--

CREATE TABLE `chat_room_messages` (
  `message_id` int(11) NOT NULL,
  `chat_room_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Fazendo dump de dados para tabela `chat_room_messages`
--

INSERT INTO `chat_room_messages` (`message_id`, `chat_room_id`, `user_id`, `message`, `created_at`) VALUES
(18, 1, 36, 'teste', '2017-08-01 12:47:48'),
(19, 1, 36, 'teste', '2017-08-01 12:48:06'),
(20, 1, 33, 'teste', '2017-08-01 12:51:32'),
(21, 1, 33, 'teste', '2017-08-01 12:53:30'),
(22, 1, 36, 'teste de novo', '2017-08-01 12:54:04'),
(23, 1, 36, 'Teste de novo', '2017-08-01 12:55:50'),
(24, 1, 36, 'teste', '2017-08-01 13:03:32'),
(25, 1, 36, 'teste', '2017-08-01 13:08:03'),
(26, 1, 36, 'teste2', '2017-08-01 13:08:12'),
(27, 1, 36, 'teste3', '2017-08-01 13:08:22');

-- --------------------------------------------------------

--
-- Estrutura para tabela `private_messages`
--

CREATE TABLE `private_messages` (
  `message_id` int(11) NOT NULL,
  `user_from_id` int(11) NOT NULL,
  `user_to_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Fazendo dump de dados para tabela `private_messages`
--

INSERT INTO `private_messages` (`message_id`, `user_from_id`, `user_to_id`, `message`, `created_at`, `is_active`) VALUES
(1, 33, 34, 'so pra ver se pega', '2017-08-01 12:47:48', 0),
(2, 33, 34, 'parece que a app esta funcionando', '2017-08-01 03:00:00', 1),
(3, 34, 33, 'Mensagem de volta', '2017-08-01 03:00:00', 0),
(4, 32, 33, 'teste 1', '2017-08-01 03:00:00', 0),
(5, 36, 33, 'opa', '2017-08-01 03:00:00', 0),
(6, 33, 36, 'ba', '2017-08-01 03:00:00', 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `gcm_registration_id` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Fazendo dump de dados para tabela `users`
--

INSERT INTO `users` (`user_id`, `name`, `email`, `gcm_registration_id`, `created_at`) VALUES
(32, 'AndroidHive', 'admin@fampfaculdade.info', '', '2017-07-29 21:30:11'),
(33, 'warllson jesus', 'warllson@outlook.com', 'dxy9Ue4bqqE:APA91bGVGCD00yBNbbOpTFHlQS47aZb5Zbb6gSozfQ7SiSbI0Odg_0fgRr6aGJKbDmmVhW7JlnnpkiQKHfuU-9CxoE0Iz1RuC04opYxKMQed1zEF-sY1HCsX70o0TybpoeF8MOn5rsyf', '2017-07-30 02:47:37'),
(34, 'cleidenisia daiana', 'daianadewsa@gmail.com', 'dxy9Ue4bqqE:APA91bGVGCD00yBNbbOpTFHlQS47aZb5Zbb6gSozfQ7SiSbI0Odg_0fgRr6aGJKbDmmVhW7JlnnpkiQKHfuU-9CxoE0Iz1RuC04opYxKMQed1zEF-sY1HCsX70o0TybpoeF8MOn5rsyf', '2017-07-30 03:38:08'),
(36, 'AndroidHive', 'admin@androidhive.info', '', '2017-07-31 23:35:50');

-- --------------------------------------------------------

--
-- Estrutura para tabela `user_chat_room`
--

CREATE TABLE `user_chat_room` (
  `user_id` int(11) NOT NULL,
  `chat_room_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_admin` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Fazendo dump de dados para tabela `user_chat_room`
--

INSERT INTO `user_chat_room` (`user_id`, `chat_room_id`, `created_at`, `is_admin`) VALUES
(33, 1, '2017-07-01 03:00:00', 1),
(33, 2, '2017-07-01 03:00:00', 0),
(34, 1, '2017-08-01 11:47:16', 0);

--
-- Índices de tabelas apagadas
--

--
-- Índices de tabela `chat_rooms`
--
ALTER TABLE `chat_rooms`
  ADD PRIMARY KEY (`chat_room_id`);

--
-- Índices de tabela `chat_room_messages`
--
ALTER TABLE `chat_room_messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `chat_room_id` (`chat_room_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Índices de tabela `private_messages`
--
ALTER TABLE `private_messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `user_from_id` (`user_from_id`),
  ADD KEY `user_to_id` (`user_to_id`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices de tabela `user_chat_room`
--
ALTER TABLE `user_chat_room`
  ADD PRIMARY KEY (`user_id`,`chat_room_id`),
  ADD KEY `chat_room_id` (`chat_room_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT de tabelas apagadas
--

--
-- AUTO_INCREMENT de tabela `chat_rooms`
--
ALTER TABLE `chat_rooms`
  MODIFY `chat_room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT de tabela `chat_room_messages`
--
ALTER TABLE `chat_room_messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;
--
-- AUTO_INCREMENT de tabela `private_messages`
--
ALTER TABLE `private_messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;
--
-- Restrições para dumps de tabelas
--

--
-- Restrições para tabelas `chat_room_messages`
--
ALTER TABLE `chat_room_messages`
  ADD CONSTRAINT `messages_ibfk_6` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `messages_ibfk_7` FOREIGN KEY (`chat_room_id`) REFERENCES `chat_rooms` (`chat_room_id`);

--
-- Restrições para tabelas `private_messages`
--
ALTER TABLE `private_messages`
  ADD CONSTRAINT `messages_ibfk_4` FOREIGN KEY (`user_from_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `messages_ibfk_5` FOREIGN KEY (`user_to_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `user_chat_room`
--
ALTER TABLE `user_chat_room`
  ADD CONSTRAINT `user_chat_room_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_chat_room_ibfk_2` FOREIGN KEY (`chat_room_id`) REFERENCES `chat_rooms` (`chat_room_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
