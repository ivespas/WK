CREATE DATABASE  IF NOT EXISTS `teste` /*!40100 DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_bin */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `teste`;
-- MySQL dump 10.13  Distrib 8.0.20, for Win64 (x86_64)
--
-- Host: localhost    Database: teste
-- ------------------------------------------------------
-- Server version	8.0.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `CODIGO` int NOT NULL AUTO_INCREMENT,
  `NOME` varchar(60) COLLATE utf8mb3_bin NOT NULL,
  `CIDADE` varchar(80) COLLATE utf8mb3_bin DEFAULT NULL,
  `ESTADO` char(2) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`CODIGO`),
  UNIQUE KEY `CODIGO_UNIQUE` (`CODIGO`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `ITEMID` int NOT NULL AUTO_INCREMENT,
  `PEDID` int NOT NULL,
  `PROID` int DEFAULT NULL,
  `QTD` float DEFAULT NULL,
  `VLRUNI` float DEFAULT NULL,
  `VLRTOT` float DEFAULT NULL,
  PRIMARY KEY (`ITEMID`),
  UNIQUE KEY `ITEMID_UNIQUE` (`ITEMID`),
  KEY `PEDIDOFK_idx` (`PEDID`),
  KEY `PRODUTOFK_idx` (`PROID`),
  CONSTRAINT `PEDIDOFK` FOREIGN KEY (`PEDID`) REFERENCES `pedido` (`PEDID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PRODUTOFK` FOREIGN KEY (`PROID`) REFERENCES `produto` (`CODIGO`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='TABELA DE ITENS DO PEDIDO';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `PEDID` int NOT NULL AUTO_INCREMENT,
  `CLIID` int DEFAULT NULL,
  `EMISSAO` date DEFAULT NULL,
  `TOTAL` float DEFAULT NULL,
  PRIMARY KEY (`PEDID`),
  KEY `CLIENTE_idx` (`CLIID`),
  KEY `EMISSAO_IDX` (`EMISSAO`),
  CONSTRAINT `CLIENTE` FOREIGN KEY (`CLIID`) REFERENCES `cliente` (`CODIGO`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produto`
--

DROP TABLE IF EXISTS `produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto` (
  `CODIGO` int NOT NULL AUTO_INCREMENT,
  `DESCRICAO` varchar(80) COLLATE utf8mb3_bin NOT NULL,
  `VALOR` float NOT NULL,
  `QTD` float DEFAULT NULL,
  PRIMARY KEY (`CODIGO`),
  UNIQUE KEY `CODIGO_UNIQUE` (`CODIGO`),
  KEY `PRODUTO_DESCR` (`DESCRICAO`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'teste'
--

--
-- Dumping routines for database 'teste'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-07 13:08:38
