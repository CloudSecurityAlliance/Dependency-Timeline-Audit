<?php

// Using Composer's autoloader
require __DIR__ . '/vendor/autoload.php';

// Importing classes from external packages
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Monolog\Logger;
use Monolog\Handler\StreamHandler;

// Importing from a package with a longer namespace
use Doctrine\ORM\EntityManager;
use Doctrine\ORM\Tools\Setup;

// Importing multiple classes from the same namespace
use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Assert;

// Aliasing an import
use Aws\S3\S3Client as AwsS3Client;

// Importing a function
use function GuzzleHttp\json_encode as guzzle_json_encode;

// Declaring a namespace for this file
namespace App\Services;

class ExampleService
{
    private $logger;
    private $entityManager;
    private $s3Client;

    public function __construct(Logger $logger, EntityManager $entityManager, AwsS3Client $s3Client)
    {
        $this->logger = $logger;
        $this->entityManager = $entityManager;
        $this->s3Client = $s3Client;
    }

    public function handleRequest(Request $request): Response
    {
        $this->logger->info('Handling request', ['method' => $request->getMethod()]);

        // Some example logic
        $data = ['message' => 'Hello, World!'];
        
        // Using the aliased function
        $jsonData = guzzle_json_encode($data);

        return new Response($jsonData, Response::HTTP_OK, ['Content-Type' => 'application/json']);
    }
}

// Example usage of PHPUnit (typically would be in a separate test file)
class ExampleTest extends TestCase
{
    public function testSomething()
    {
        Assert::assertTrue(true);
    }
}
