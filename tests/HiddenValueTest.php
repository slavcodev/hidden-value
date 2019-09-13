<?php
/**
 * This file is part of Zee Project.
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * @see https://github.com/zee/
 */

declare(strict_types=1);

namespace Zee\HiddenValue\Tests;

use PHPUnit\Framework\TestCase;
use Zee\HiddenValue\HiddenValue;

final class HiddenValueTest extends TestCase
{
    /**
     * @test
     * @dataProvider provideSensitiveValues
     *
     * @param mixed $sensitiveValue
     */
    public function readValueUsingExplicitCallOfGetter($sensitiveValue): void
    {
        $hiddenValue = $this->createValue($sensitiveValue);
        self::assertSame($sensitiveValue, $hiddenValue->getValue());
    }

    /**
     * @test
     */
    public function cannotCastToString(): void
    {
        $value = $this->createValue('foo');
        self::assertEmpty((string) $value);
    }

    /**
     * @test
     */
    public function valueIsHiddenInDump(): void
    {
        $value = $this->createValue('foo');
        ob_clean();
        ob_start();
        var_dump($value);
        $dump = ob_get_clean();
        self::assertStringNotContainsString('foo', $dump);
    }

    /**
     * @test
     */
    public function valueIsHiddenInJsonEncodedValue(): void
    {
        $value = $this->createValue('foo');
        $json = json_encode($value);
        self::assertSame('null', $json);
        self::assertNull(json_decode($json));
    }

    public function provideSensitiveValues(): iterable
    {
        return [
            'any scalar value' => ['foo'],
            'array' => [['foo']],
            'object' => [(object) ['foo']],
        ];
    }

    /**
     * @param mixed $value
     */
    private function createValue($value): HiddenValue
    {
        return new HiddenValue(
            function () use ($value) {
                return $value;
            }
        );
    }
}
