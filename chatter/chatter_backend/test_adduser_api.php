<?php
// Simple test script to test the addUser API endpoint

$baseUrl = "http://192.168.100.4:8000";

// Test data for registration
$testData = [
    'identity' => 'test.user@example.com',
    'full_name' => 'Test User',
    'login_type' => '0',  // email
    'device_type' => '0', // Android
    'device_token' => 'test_device_token_12345',
];

// Initialize cURL
$ch = curl_init();

curl_setopt_array($ch, [
    CURLOPT_URL => $baseUrl . '/api/addUser',
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => http_build_query($testData),
    CURLOPT_HTTPHEADER => [
        'apikey: 123',
        'Content-Type: application/x-www-form-urlencoded',
    ],
    CURLOPT_TIMEOUT => 10,
    CURLOPT_VERBOSE => true,
]);

echo "Testing addUser API endpoint...\n";
echo "URL: " . $baseUrl . "/api/addUser\n";
echo "Test Data:\n";
print_r($testData);
echo "\n";

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlError = curl_error($ch);

curl_close($ch);

echo "HTTP Status Code: $httpCode\n";
if ($curlError) {
    echo "cURL Error: $curlError\n";
} else {
    echo "Response:\n";
    echo json_encode(json_decode($response), JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . "\n";
}
?>
