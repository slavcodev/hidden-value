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

namespace Zee\HiddenValue;

use Closure;
use JsonSerializable;

final class HiddenValue implements JsonSerializable
{
    /**
     * @var mixed
     */
    private $value;

    public function __construct(Closure $builder)
    {
        $this->value = $builder();
    }

    /**
     * Restricts output.
     */
    public function __toString(): string
    {
        return '';
    }

    /**
     * Restricts output.
     */
    public function __debugInfo(): array
    {
        return [];
    }

    /**
     * Restricts output.
     *
     * @return mixed
     */
    public function jsonSerialize()
    {
        return null;
    }

    /**
     * @return mixed
     */
    public function getValue()
    {
        return $this->value;
    }
}
